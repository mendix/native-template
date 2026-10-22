# Google ML Kit (pulled in by react-native-vision-camera-barcode-scanner) ships fat static
# frameworks with only an x86_64 simulator slice and an arm64 *device* slice. Linking an arm64
# simulator build (Apple Silicon) fails with:
#   building for 'iOS-simulator', but linking in object file ... built for 'iOS'
#
# A fat binary can't hold two arm64 slices, so we keep the original frameworks untouched for
# device builds and archives, and create a copy next to them ("Frameworks-simulator") whose arm64
# objects are re-tagged as iOS-simulator (LC_BUILD_VERSION platform 2 -> 7). The generated
# xcconfigs then point FRAMEWORK_SEARCH_PATHS at "$(MLKIT_FRAMEWORKS_DIR)", which only resolves to
# the copy for sdk=iphonesimulator*, so only simulator builds ever link the patched binaries.
#
# The ML Kit podspecs also set EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64 (forcing Rosetta),
# which leaves the Pods aggregate target with no architectures on an arm64 simulator, so that
# arm64 exclusion is dropped as well unless another pod asks for it too.
require 'fileutils'

module MLKitSimulatorSupport
  POD_NAME_PATTERN = /\A(GoogleMLKit|MLKit|MLImage)/
  SIMULATOR_FRAMEWORKS_DIR = "Frameworks-simulator"
  SIMULATOR_EXCLUDED_ARCHS = "EXCLUDED_ARCHS[sdk=iphonesimulator*]"
  FRAMEWORKS_DIR_SETTING = "MLKIT_FRAMEWORKS_DIR"

  FAT_MAGIC = 0xcafebabe
  MH_MAGIC_64 = 0xfeedfacf
  CPU_TYPE_ARM64 = 0x0100000c
  LC_BUILD_VERSION = 0x32
  PLATFORM_IOS = 2
  PLATFORM_IOSSIMULATOR = 7

  module_function

  def apply(installer)
    pods_root = installer.sandbox.root
    pods = installer.pod_targets.map(&:pod_name).uniq.select { |name| name =~ POD_NAME_PATTERN }
    pods = pods.select { |pod| create_simulator_frameworks(pods_root + pod) }
    return if pods.empty?

    Pod::UI.puts "Adding arm64 simulator support for #{pods.join(', ')}".green
    include_arm64 = !other_pods_exclude_arm64?(installer)
    xcconfig_paths(installer).each { |path| update_xcconfig(path, pods, include_arm64) }
  end

  def other_pods_exclude_arm64?(installer)
    others = installer.pod_targets.reject { |target| target.pod_name =~ POD_NAME_PATTERN }
    names = others.select do |target|
      target.spec_consumers.any? do |consumer|
        [consumer.user_target_xcconfig, consumer.pod_target_xcconfig].any? do |xcconfig|
          xcconfig[SIMULATOR_EXCLUDED_ARCHS].to_s.split.include?("arm64")
        end
      end
    end.map(&:pod_name)
    return false if names.empty?

    Pod::UI.warn "#{names.join(', ')} exclude arm64 for the simulator, so arm64 simulator builds will not work."
    true
  end

  def create_simulator_frameworks(pod_dir)
    frameworks_dir = pod_dir + "Frameworks"
    return false unless frameworks_dir.directory?

    simulator_dir = pod_dir + SIMULATOR_FRAMEWORKS_DIR
    FileUtils.rm_rf(simulator_dir)
    FileUtils.mkdir_p(simulator_dir)
    Dir.glob(frameworks_dir + "*.framework").each do |framework|
      FileUtils.cp_r(framework, simulator_dir)
      name = File.basename(framework, ".framework")
      patch_binary(simulator_dir + "#{name}.framework" + name)
    end
    true
  end

  def xcconfig_paths(installer)
    aggregate = installer.aggregate_targets.flat_map do |target|
      target.xcconfigs.keys.map { |variant| target.xcconfig_path(variant) }
    end
    pod_targets = installer.pod_targets.flat_map do |target|
      target.build_settings.keys.map { |variant| target.xcconfig_path(variant) }
    end
    (aggregate + pod_targets).uniq.select { |path| File.exist?(path) }
  end

  def update_xcconfig(path, pods, include_arm64)
    original = File.read(path)
    lines = original.lines.reject { |line| line.start_with?(FRAMEWORKS_DIR_SETTING) }

    search_paths = lines.index { |line| line.start_with?("FRAMEWORK_SEARCH_PATHS =") }
    if search_paths
      line = pods.reduce(lines[search_paths]) do |value, pod|
        value.gsub("\"${PODS_ROOT}/#{pod}/Frameworks\"", "\"${PODS_ROOT}/#{pod}/$(#{FRAMEWORKS_DIR_SETTING})\"")
      end
      if line != lines[search_paths]
        lines[search_paths] = line
        lines << "\n" unless lines.last.end_with?("\n")
        lines << "#{FRAMEWORKS_DIR_SETTING} = Frameworks\n"
        lines << "#{FRAMEWORKS_DIR_SETTING}[sdk=iphonesimulator*] = #{SIMULATOR_FRAMEWORKS_DIR}\n"
      end
    end

    if include_arm64
      lines = lines.map do |line|
        next line unless line.start_with?("#{SIMULATOR_EXCLUDED_ARCHS} =")

        archs = line.delete_prefix("#{SIMULATOR_EXCLUDED_ARCHS} =").split - ["arm64"]
        archs.empty? ? nil : "#{SIMULATOR_EXCLUDED_ARCHS} = #{archs.join(' ')}\n"
      end.compact
    end

    File.write(path, lines.join) if lines.join != original
  end

  def patch_binary(path)
    buf = File.binread(path)
    patched = 0
    if be32(buf, 0) == FAT_MAGIC
      be32(buf, 4).times do |i|
        arch = 8 + i * 20
        next unless be32(buf, arch) == CPU_TYPE_ARM64

        start = be32(buf, arch + 8)
        patched += patch_slice(buf, start, start + be32(buf, arch + 12))
      end
    else
      patched += patch_slice(buf, 0, buf.bytesize)
    end
    File.binwrite(path, buf) if patched > 0
  end

  def patch_slice(buf, start, finish)
    buf.byteslice(start, 8) == "!<arch>\n" ? patch_archive(buf, start, finish) : patch_mach_o(buf, start)
  end

  def patch_archive(buf, start, finish)
    offset = start + 8
    patched = 0
    while offset + 60 <= finish
      name = buf.byteslice(offset, 16).strip
      size = buf.byteslice(offset + 48, 10).strip.to_i
      data = offset + 60
      # BSD long names: "#1/<len>" means the name is stored at the start of the member data.
      data += name[3..].to_i if name.start_with?("#1/")
      patched += patch_mach_o(buf, data)
      offset += 60 + size + (size % 2)
    end
    patched
  end

  def be32(buf, offset)
    buf.byteslice(offset, 4).unpack("N").first
  end

  def le32(buf, offset)
    buf.byteslice(offset, 4).unpack("V").first
  end

  def patch_mach_o(buf, offset)
    return 0 unless le32(buf, offset) == MH_MAGIC_64 && le32(buf, offset + 4) == CPU_TYPE_ARM64

    cmd_offset = offset + 32
    patched = 0
    le32(buf, offset + 16).times do
      if le32(buf, cmd_offset) == LC_BUILD_VERSION && le32(buf, cmd_offset + 8) == PLATFORM_IOS
        buf[cmd_offset + 8, 4] = [PLATFORM_IOSSIMULATOR].pack("V")
        patched += 1
      end
      cmd_offset += le32(buf, cmd_offset + 4)
    end
    patched
  end
end

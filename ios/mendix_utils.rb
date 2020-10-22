require "json"

def generate_pod_dependencies
  resolved_pods = {}

  capabilities_setup_config = get_capabilities_setup_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      next
    end

    next unless capability["ios"] && pods = capability["ios"]["pods"]
    resolved_pods.merge! pods
  end

  modules = get_react_native_config["dependencies"]
  get_unlinked_dependency_config.each do |name, options|
    next unless options["ios"] && modules.include?(name) && pods = options["ios"]["pods"]
    resolved_pods.merge! pods
  end

  include_pods(resolved_pods.compact)
end

def generate_mendix_delegate
  imports = []
  hooks = {
    didFinishLaunchingWithOptions: [],
    didReceiveLocalNotification: [],
    didReceiveRemoteNotification: [],
    didRegisterUserNotificationSettings: [],
    openURL: [],
  }

  capabilities_setup_config = get_capabilities_setup_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      next
    end

    next if capability["ios"].nil?

    Pod::UI.notice "Capability for '#{name.to_s}' was enabled for this project."

    next unless capability = capability["ios"]["AppDelegate"]

    imports << capability["imports"] if !capability["imports"].nil?

    hooks.each do |name, hook|
      hook << capability[name.to_s].map { |line| "  #{line}" } if !capability[name.to_s].nil?
    end
  end

  File.open("MendixAppDelegate.m", "w") do |file|
    mendix_app_delegate = mendix_app_delegate_template.sub("{{ imports }}", stringify(imports))
    hooks.each { |name, hook| mendix_app_delegate.sub!("{{ #{name.to_s} }}", stringify(hook)) }
    file << mendix_app_delegate
  end
end

def mendix_app_delegate_template
  %(// DO NOT EDIT BY HAND. THIS FILE IS AUTO-GENERATED
#import <Foundation/Foundation.h>
#import "MendixAppDelegate.h"
{{ imports }}

@implementation MendixAppDelegate

+ (void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
{{ didFinishLaunchingWithOptions }}
}

+ (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
{{ didReceiveLocalNotification }}
}

+ (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
{{ didReceiveRemoteNotification }}
}

+ (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
{{ didRegisterUserNotificationSettings }}
}

+ (void) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
{{ openURL }}
}

@end\n)
end

def stringify(array)
  array.flatten.uniq.join("\n")
end

def read_json_file_gracefully(path)
  file_path = File.join(__dir__, "..", path)
  JSON.parse(File.read(file_path)) if File.exists?(file_path)
end

def get_unlinked_dependency_config
  read_json_file_gracefully("unlinked-dependency-config.json") || {}
end

def get_capabilities_setup_config
  read_json_file_gracefully("capabilities-setup-config.json") || {}
end

def get_project_capabilities
  read_json_file_gracefully("capabilities.ios.json") || {}
end

# Source @react-native-community/cli-platform-ios/native_modules
def get_react_native_config
  cli_command = "try {console.log(require('@react-native-community/cli').bin);} catch (e) {console.log(require('react-native/cli').bin);}"
  cli_result = Pod::Executable.execute_command("node", ["-e", cli_command], true).strip

  json = []
  IO.popen(["node", cli_result, "config"]) do |data|
    while line = data.gets
      json << line
    end
  end

  JSON.parse(json.join("\n"))
end

def include_pods(pods = {})
  pods.each do |name, pod|
    if pod["path"] != nil && !pod["path"].empty?
      pod name, :path => "../node_modules/#{pod["path"]}"
    elsif pod["version"] != nil && !pod["version"].empty?
      pod name, pod["version"]
    else
      pod name
    end
  end
end

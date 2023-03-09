require "json"

def generate_pod_dependencies
  resolved_pods = {}

  capabilities_setup_config = get_capabilities_setup_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      unless get_excluded_capabilities.include?(name.to_s)
        Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      end
      next
    end

    next unless config = capability["ios"]

    if !config["pods"].nil?
      resolved_pods.merge! config["pods"]
    end

    if !config["buildPhases"].nil?
      include_script_phases(config["buildPhases"])
    end
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
    willPresentNotification: [],
    didReceiveNotificationResponse: [],
    getJSBundleFile: [],
  }

  returnHooks = {
    boolean_openURLWithOptions: [],
  }

  capabilities_setup_config = get_capabilities_setup_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      unless get_excluded_capabilities.include?(name.to_s)
        Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      end
      next
    end

    next if capability["ios"].nil?

    Pod::UI.notice "Capability for '#{name.to_s}' was enabled for this project."

    next unless capability = capability["ios"]["AppDelegate"]

    imports << capability["imports"] if !capability["imports"].nil?

    hooks.each do |name, hook|
      hook << capability[name.to_s].map { |line| "  #{line}" } if !capability[name.to_s].nil?
    end

    returnHooks.each do |name, hook|
      hook << capability[name.to_s].map { |line| "  #{line}" } if !capability[name.to_s].nil?
    end
  end

  File.open("MendixAppDelegate.m", "w") do |file|
    mendix_app_delegate = mendix_app_delegate_template.sub("{{ imports }}", stringify(imports))
    hooks.each { |name, hook| mendix_app_delegate.sub!("{{ #{name.to_s} }}", stringify(hook)) }
    returnHooks.each { |name, hook| mendix_app_delegate.sub!("{{ #{name.to_s} }}", stringify(hook).length > 0 ? stringify(hook) : "  return YES;") }
    file << mendix_app_delegate
  end
end

def mendix_app_delegate_template
  %(// DO NOT EDIT BY HAND. THIS FILE IS AUTO-GENERATED
#import <Foundation/Foundation.h>
#import <MendixNative.h>
#import "MendixAppDelegate.h"
{{ imports }}

@implementation MendixAppDelegate

static UIResponder<UIApplicationDelegate, UNUserNotificationCenterDelegate> *_Nullable delegate;

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

+ (BOOL) application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
{{ boolean_openURLWithOptions }}
}

+ (void) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
{{ openURL }}
}

+ (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
{{ willPresentNotification }}
}

+ (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
{{ didReceiveNotificationResponse }}
}

+ (UIResponder<UIApplicationDelegate, UNUserNotificationCenterDelegate> *_Nullable) delegate {
  return delegate;
}

+ (void) setDelegate:(UIResponder<UIApplicationDelegate, UNUserNotificationCenterDelegate> *_Nonnull)value {
  delegate = value;
}

+ (NSURL *) getJSBundleFile {
{{ getJSBundleFile }}
  return [ReactNative.instance getJSBundleFile];
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

def include_script_phases(phases)
  phases.each do |phase|
    if phase["path"]
      phase["script"] = File.read(File.expand_path(phase["path"], ".."))
      phase.delete("path")
    end

    if phase["execution_position"]
      phase["execution_position"] = phase["execution_position"].to_sym
    end

    phase = Hash[phase.map { |k, v| [k.to_sym, v] }]
    script_phase phase
  end
end

def get_excluded_capabilities
    ["nativeOTA"]
end

require "json"

def generate_pod_dependencies
  modules = get_react_native_config["dependencies"]
  capabilities_setup_config = get_capabilities_setup_config
  unlinked_dependency_config = get_unlinked_dependency_config

  pods = {}

  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      next
    end

    next if capability["ios"].nil? || capability["ios"]["pods"].nil?

    pods = pods.merge capability["ios"]["pods"]
  end

  unlinked_dependency_config.each do |name, options|
    next if options["ios"].nil? || !modules.include?(name)
    pods = pods.merge options["ios"]["pods"]
  end

  include_pods(pods.compact)
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

  capabilities = []
  capabilities_setup_config = get_capabilities_setup_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = capabilities_setup_config[name.to_s]
    if capability.nil?
      Pod::UI.warn "Capability for '#{name.to_s}' is not valid. This file should not be manipulated without guidance."
      next
    end

    next if capability["ios"].nil?

    Pod::UI.notice "Capability for '#{name.to_s}' was enabled for this project."
    capabilities << capability["ios"]["AppDelegate"] if !capability["ios"]["AppDelegate"].nil?
  end

  capabilities.each do |options|
    imports << options["imports"] if !options["imports"].nil?

    hooks.each do |name, hook|
      hook << options[name.to_s].map { |line| "#{line}" } if !options[name.to_s].nil?
    end
  end

  File.open("MendixAppDelegate.m", "w") do |file|
    file << replace_template_with_values(
      imports.flatten.uniq.join("\n"),
      hooks[:didFinishLaunchingWithOptions].flatten.uniq.join("\n"),
      hooks[:didReceiveLocalNotification].flatten.uniq.join("\n"),
      hooks[:didReceiveRemoteNotification].flatten.uniq.join("\n"),
      hooks[:didRegisterUserNotificationSettings].flatten.uniq.join("\n"),
      hooks[:openURL].flatten.uniq.join("\n")
    )
  end
end

def replace_template_with_values(
  imports,
  didFinishLaunchingWithOptions,
  didReceiveLocalNotification,
  didReceiveRemoteNotification,
  didRegisterUserNotificationSettings,
  openURL
)
  %(// DO NOT EDIT BY HAND. THIS FILE IS AUTO-GENERATED
#import <Foundation/Foundation.h>
#import "MendixAppDelegate.h"
#{imports}

@implementation MendixAppDelegate

+ (void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	#{didFinishLaunchingWithOptions}
}

+ (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	#{didReceiveLocalNotification}
}

+ (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
	#{didReceiveRemoteNotification}
}

+ (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	#{didRegisterUserNotificationSettings}
}

+ (void) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	#{openURL}
}

@end
	)
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
  read_json_file_gracefully("capabilities.json") || {}
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

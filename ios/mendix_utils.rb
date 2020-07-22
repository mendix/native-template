require "json"

def generate_pod_dependencies
  modules = get_react_native_config["dependencies"]
  config = get_project_config
  config["dependencies"].each do |name, options|
    include_pods(name, options["ios"]["pods"]) if modules.include?(name)
  end
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
  config = get_project_config
  get_project_capabilities.select { |_, value| value == true }.each do |name, _|
    capability = config["capabilities"][name.to_s]
    if capability.nil?
      Pod::UI.warn "'#{name.to_s}' is not a valid Mendix capability. This file should not be manipulated without guidance."
      next
    end

    Pod::UI.notice "'#{name.to_s}' capability was enabled for this project."
    capabilities << capability["ios"]
  end

  capabilities.each do |options|
    imports << options["imports"].map { |import| "#import #{import}" } if !options["imports"].nil?

    if !options["hooks"].nil?
      hooks.each do |name, hook|
        hook << options["hooks"][name.to_s].map { |line| "#{line};" } if !options["hooks"][name.to_s].nil?
      end
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

def get_project_config
  JSON.parse(File.read(File.join(__dir__, "..", "config.json")))
end

def get_project_capabilities
  JSON.parse(File.read(File.join(__dir__, "..", "capabilities.json")))
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

def include_pods(name, pods)
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

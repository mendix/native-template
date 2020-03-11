#import <Firebase.h>
#import "AppDelegate.h"
#import "MendixNative/MendixNative.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "RNFirebase/RNFirebaseNotifications.h"
#import "RNFirebase/RNFirebaseMessaging.h"

@implementation AppDelegate

@synthesize shouldOpenInLastApp;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  if (self.useFirebase) {
    [FIRApp configure];
    [RNFirebaseNotifications configure];
  }

  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *targetName = [mainBundle objectForInfoDictionaryKey:@"TargetName"] ?: @"";

  if ([targetName  isEqual: @"dev"]) {
    IQKeyboardManager.sharedManager.enable = NO;

    if (launchOptions == nil) {
      return YES;
    }

    NSString *url = [AppPreferences getAppUrl];
    if (url == nil) {
      return YES;
    }
    
    shouldOpenInLastApp = YES;
    NSURL *bundleUrl = [AppUrl forBundle:url port:[AppPreferences getRemoteDebuggingPackagerPort] isDebuggingRemotely:[AppPreferences remoteDebuggingEnabled] isDevModeEnabled:[AppPreferences devModeEnabled]];
    NSURL *runtimeUrl = [AppUrl forRuntime:url];
    MendixApp *mendixApp = [[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:[self getWarningFilterValue] isDeveloperApp:YES clearDataAtLaunch:NO reactLoadingStoryboard:nil];
    [ReactNative.instance setup:mendixApp launchOptions:launchOptions];

    return YES;
  }

  NSString *url = [mainBundle objectForInfoDictionaryKey:@"Runtime url"];
  if (url == nil) {
    [NSException raise:@"RuntimeURLMissing" format:@"Missing the 'Runtime url' configuration within the Info.plist file"];
  }
  NSURL *runtimeUrl = [AppUrl forRuntime:[url stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
  NSURL *bundleUrl = [ReactNative.instance getJSBundleFile];
  
  [ReactNative.instance setup:[[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:none isDeveloperApp:false clearDataAtLaunch:false reactLoadingStoryboard:nil] launchOptions:launchOptions];
  [ReactNative.instance start];

  return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  if (self.useFirebase) {
    [[RNFirebaseNotifications instance] didReceiveLocalNotification:notification];
  }
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
  if (self.useFirebase) {
    [[RNFirebaseNotifications instance] didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  }
}

- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  if (self.useFirebase) {
    [[RNFirebaseMessaging instance] didRegisterUserNotificationSettings:notificationSettings];
  }
}

- (BOOL) useFirebase {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (WarningsFilter) getWarningFilterValue {
#if DEBUG
  return all;
#else
  return [AppPreferences devModeEnabled] ? partial : none;
#endif
}

@end

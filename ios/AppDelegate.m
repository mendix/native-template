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
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = [UIViewController new];
  [self.window makeKeyAndVisible];

  NSString *url = [mainBundle objectForInfoDictionaryKey:@"Runtime url"];
  if (url == nil || [url length] == 0) {
    [self showUnrecoverableDialogWithTitle:@"The runtime URL is missing" message:@"Missing the 'Runtime url' configuration within the Info.plist file. The app will close."];
    return NO;
  }
  NSURL *runtimeUrl = [AppUrl forRuntime:[url stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
  NSURL *bundleUrl = [ReactNative.instance getJSBundleFile];
  
  if (bundleUrl != nil) {
    [ReactNative.instance setup:[[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:none isDeveloperApp:false clearDataAtLaunch:false reactLoadingStoryboard:nil] launchOptions:launchOptions];
    [ReactNative.instance start];
  } else {
    [self showUnrecoverableDialogWithTitle:@"No Mendix bundle found" message:@"Missing the Mendix app bundle. Make sure that the index.ios.bundle file is available in ios/NativeTemplate/Bundle folder. If building locally consult the documentation on how to generate a bundle from your project."];
  }

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

- (void) showUnrecoverableDialogWithTitle:(NSString *)title message:(NSString *) message {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [NSException raise:@"UnrecoverableError" format:message];
  }]];
  [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end

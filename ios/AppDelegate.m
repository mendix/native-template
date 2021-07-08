#import "AppDelegate.h"
#import "MendixAppDelegate.h"
#import "MendixNative/MendixNative.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "SplashScreenPresenter.h"

@implementation AppDelegate

@synthesize shouldOpenInLastApp;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [MendixAppDelegate application:application didFinishLaunchingWithOptions:launchOptions];
  [self setupUI];

  NSBundle *mainBundle = [NSBundle mainBundle];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = [UIViewController new];
  [self.window makeKeyAndVisible];

  NSString *url = [mainBundle objectForInfoDictionaryKey:@"Runtime url"];
  if (url == nil || [url length] == 0) {
    [self showUnrecoverableDialogWithTitle:@"The runtime URL is missing" message:@"Missing the 'Runtime url' configuration within the Info.plist file. The app will close."];
    return NO;
  }
  NSURL *runtimeUrl = [AppUrl forRuntime:[url stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
  NSURL *bundleUrl = [MendixAppDelegate getJSBundleFile];

  if (bundleUrl != nil) {
    [ReactNative.instance setup:[[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:none isDeveloperApp:NO clearDataAtLaunch:NO splashScreenPresenter:[SplashScreenPresenter new]] launchOptions:launchOptions];
    [ReactNative.instance start];
  } else {
    [self showUnrecoverableDialogWithTitle:@"No Mendix bundle found" message:@"Missing the Mendix app bundle. Make sure that the index.ios.bundle file is available in ios/NativeTemplate/Bundle folder. If building locally consult the documentation on how to generate a bundle from your project."];
  }

  return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  [MendixAppDelegate application:application didReceiveLocalNotification:notification];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
  [MendixAppDelegate application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  [MendixAppDelegate application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  [MendixAppDelegate application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	return [MendixAppDelegate application:app openURL:url options:options];
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

- (void) setupUI {
  if (@available(iOS 13.4, *)) {
    [UIDatePicker appearance].preferredDatePickerStyle = UIDatePickerStyleWheels;
  }
}
@end

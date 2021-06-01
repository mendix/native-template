#import "AppDelegate.h"
#import "MendixAppDelegate.h"
#import "MendixNative.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "SplashScreenPresenter.h"

@implementation AppDelegate

@synthesize shouldOpenInLastApp;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [MendixAppDelegate application:application didFinishLaunchingWithOptions:launchOptions];
  [self setupUI];

  IQKeyboardManager.sharedManager.enable = NO;
  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	BOOL handled = [MendixAppDelegate application:app openURL:url options:options];
	
	NSString *runtimeUrl = [AppPreferences getAppUrl];
	if ([ReactNative.instance isActive] || !handled || runtimeUrl == nil ) {
		return handled;
  }
	
  NSURL *bundleUrl = [AppUrl forBundle:runtimeUrl port:[AppPreferences getRemoteDebuggingPackagerPort] isDebuggingRemotely:[AppPreferences remoteDebuggingEnabled] isDevModeEnabled:[AppPreferences devModeEnabled]];
  NSURL *runtimeUrlFormatted = [AppUrl forRuntime:runtimeUrl];
  NSMutableDictionary *launchOptions = [options mutableCopy];
	[launchOptions setValue:[options valueForKey:UIApplicationOpenURLOptionsAnnotationKey] forKey:UIApplicationOpenURLOptionsAnnotationKey];
	[launchOptions setValue:url forKey:UIApplicationLaunchOptionsURLKey];
  MendixApp *mendixApp = [[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrlFormatted warningsFilter:[self getWarningFilterValue] isDeveloperApp:YES clearDataAtLaunch:NO];
  [ReactNative.instance setup:mendixApp launchOptions:launchOptions];
  [ReactNative.instance start];
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

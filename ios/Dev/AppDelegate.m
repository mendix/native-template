#import "AppDelegate.h"
#import "MendixAppDelegate.h"
#import "MendixNative.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "SplashScreenPresenter.h"

@implementation AppDelegate

@synthesize shouldOpenInLastApp;
@synthesize hasHandledLaunchAppWithOptions;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  MendixAppDelegate.delegate = self;
  [MendixAppDelegate application:application didFinishLaunchingWithOptions:launchOptions];
  [self setupUI];

  IQKeyboardManager.sharedManager.enable = NO;
  self.window = [[MendixReactWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchApp" bundle:nil];
  self.window.rootViewController = [storyboard instantiateInitialViewController];
  [self.window makeKeyAndVisible];
  [self.window setUserInteractionEnabled:YES];
  
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

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	BOOL isHandled = [MendixAppDelegate application:application openURL:url options:options];

  NSString *appUrl = [AppPreferences getAppUrl];
  if (!isHandled || appUrl == nil || [appUrl length] == 0 || [ReactNative.instance isActive]) {
    return NO;
  }

  NSURL *bundleUrl = [AppUrl forBundle:appUrl port:[AppPreferences getRemoteDebuggingPackagerPort] isDebuggingRemotely:[AppPreferences remoteDebuggingEnabled] isDevModeEnabled:[AppPreferences devModeEnabled]];
  NSURL *runtimeUrl = [AppUrl forRuntime:appUrl];
  NSMutableDictionary *launchOptions = [options mutableCopy];
	[launchOptions setValue:[options valueForKey:UIApplicationOpenURLOptionsAnnotationKey] forKey:UIApplicationOpenURLOptionsAnnotationKey];
	[launchOptions setValue:url forKey:UIApplicationLaunchOptionsURLKey];
  MendixApp *mendixApp = [[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:[self getWarningFilterValue] isDeveloperApp:YES clearDataAtLaunch:NO];
  [ReactNative.instance setup:mendixApp launchOptions:launchOptions];
  dispatch_after(2.0, dispatch_get_main_queue(), ^(void){
  	[ReactNative.instance start];
  });

  return isHandled;
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

- (void) userNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  [MendixAppDelegate userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void) userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler {
  [MendixAppDelegate userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}
@end

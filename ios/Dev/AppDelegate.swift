import Foundation
import MendixNative

@UIApplicationMain
class AppDelegate: ReactAppProvider, UNUserNotificationCenterDelegate {
  
  var shouldOpenInLastApp = false
  var hasHandledLaunchAppWithOptions = false
  
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
    setUpProvider()
    super.application(application, didFinishLaunchingWithOptions: launchOptions)
    clearKeychain()
    MendixAppDelegate.delegate = self
    UNUserNotificationCenter.current().delegate = self
    MendixAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    setupUI()
    
    IQKeyboardManager.shared().isEnabled = false
    
    let controller = UIStoryboard.launchApp.instantiateInitialViewController() ?? UIViewController()
    changeRoot(to: controller)
    window.isUserInteractionEnabled = true
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    MendixAppDelegate.userNotificationCenter(center, willPresentNotification: notification, withCompletionHandler: completionHandler)
  }
  
  func getWarningFilterValue() -> WarningsFilter {
    #if DEBUG
    return .all
    #else
    return AppPreferences.devModeEnabled ? .partial : .none
    #endif
  }
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    
    let handled = MendixAppDelegate.application(app, openURL: url, options: options)
    
    let appUrl = AppPreferences.safeAppUrl
    
    if (!handled || appUrl.isEmpty || ReactAppProvider.isReactAppActive()) {
      return false
    }
    
    let bundleUrl = AppUrl.forBundle(
        appUrl,
        port: AppPreferences.remoteDebuggingPackagerPort,
        isDebuggingRemotely: AppPreferences.remoteDebuggingEnabled,
        isDevModeEnabled: AppPreferences.devModeEnabled
    )
    
    let launchOptions = NSMutableDictionary(dictionary: options)
    launchOptions[UIApplicationLaunchOptionsKey.url] = url
    launchOptions[UIApplicationOpenURLOptionsKey.annotation] = options[UIApplicationOpenURLOptionsKey.annotation]
    
    let mxApp = MendixApp.init(
        identifier: nil,
        bundleUrl: bundleUrl,
        runtimeUrl: AppUrl.forRuntime(appUrl),
        warningsFilter: getWarningFilterValue(),
        isDeveloperApp: true,
        clearDataAtLaunch: false,
        splashScreenPresenter: nil,
        reactLoading: nil,
        enableThreeFingerGestures: false
    )
    
    ReactNative.shared.setup(mxApp, launchOptions: launchOptions as? [AnyHashable : Any])
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      ReactNative.shared.start()
    }
    
    return handled
  }
//
//  - (void) userNotificationCenter:(UNUserNotificationCenter *)center
//      didReceiveNotificationResponse:(UNNotificationResponse *)response
//               withCompletionHandler:(void (^)(void))completionHandler {
//    [MendixAppDelegate userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
//  }
//
//  - (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [MendixAppDelegate application:application didReceiveLocalNotification:notification];
//  }
//
//  - (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
//  fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
//    [MendixAppDelegate application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
//  }
//
//  - (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    [MendixAppDelegate application:application didRegisterUserNotificationSettings:notificationSettings];
//  }
}

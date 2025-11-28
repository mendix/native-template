import Foundation
import MendixNative

@UIApplicationMain
class AppDelegate: ReactAppProvider {
  
  var shouldOpenInLastApp = false
  var hasHandledLaunchAppWithOptions = false
  
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
    MendixAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    setupApp(application: application, launchOptions: launchOptions)
    
    IQKeyboardManager.shared().isEnabled = false
    
    let controller = UIStoryboard.launchApp.instantiateInitialViewController() ?? UIViewController()
    changeRoot(to: controller)
    window.isUserInteractionEnabled = true
    
    return true
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
    ReactNative.shared.start()
    
    return handled
  }
}

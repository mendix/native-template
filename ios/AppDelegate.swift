import MendixNative

@UIApplicationMain
class AppDelegate: ReactAppProvider, UNUserNotificationCenterDelegate {
  
  var shouldOpenInLastApp = false
  var hasHandledLaunchAppWithOptions = false
  
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
    setupApp(application: application, launchOptions: launchOptions)
    MendixAppDelegate.delegate = self
    UNUserNotificationCenter.current().delegate = self
    MendixAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    changeRoot(to: UIViewController())
    
    guard let url = Bundle.main.object(forInfoDictionaryKey: "Runtime url") as? String, !url.isEmpty else {
      showUnrecoverableDialog(
        title: "The runtime URL is missing",
        message: "Missing the 'Runtime url' configuration within the Info.plist file. The app will close."
      )
      return false
    }
    
    if let bundleUrl = MendixAppDelegate.getJSBundleFile() {
      
      let runtimeUrl = AppUrl.forRuntime((url).replacingOccurrences(of: "\\", with: ""))
      
      let mendixApp = MendixApp(
        identifier: nil,
        bundleUrl: bundleUrl,
        runtimeUrl: runtimeUrl,
        warningsFilter: .none,
        isDeveloperApp: false,
        clearDataAtLaunch: false,
        splashScreenPresenter: SplashScreenPresenter(),
        reactLoading: nil,
        enableThreeFingerGestures: false
      )
      
      ReactNative.shared.setup(mendixApp, launchOptions: launchOptions)
      ReactNative.shared.start()
    } else {
      showUnrecoverableDialog(
        title: "No Mendix bundle found",
        message: "Missing the Mendix app bundle. Make sure that the index.ios.bundle file is available in ios/NativeTemplate/Bundle folder. If building locally consult the documentation on how to generate a bundle from your project."
      )
    }
    
    return true
  }
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return MendixAppDelegate.application(app, openURL: url, options: options)
  }
  
  func getWarningFilterValue() -> WarningsFilter {
    return .none
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    MendixAppDelegate.userNotificationCenter(center, willPresentNotification: notification, withCompletionHandler: completionHandler)
  }
}

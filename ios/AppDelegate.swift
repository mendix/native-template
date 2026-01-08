import MendixNative

@UIApplicationMain
class AppDelegate: ReactAppProvider {
  
  var shouldOpenInLastApp = false
  var hasHandledLaunchAppWithOptions = false
  
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    SessionCookieStore.restore() // iOS does not persist session cookies across app restarts, this helps persisting session cookies to match behaviour with Android
    MendixAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    setupApp(application: application, launchOptions: launchOptions)
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
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return MendixAppDelegate.application(app, openURL: url, options: options)
  }
  
  func getWarningFilterValue() -> WarningsFilter {
    return .none
  }
  
  override func applicationWillTerminate(_ application: UIApplication) {
    SessionCookieStore.persist() // iOS does not persist session cookies across app restarts, this helps persisting session cookies to match behaviour with Android
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    SessionCookieStore.persist() // iOS does not persist session cookies across app restarts, this helps persisting session cookies to match behaviour with Android
  }
}

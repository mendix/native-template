import UIKit
import MendixNative

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  @objc var window: UIWindow? {
    get { SceneDelegate.delegateInstance()?.window }
    set { SceneDelegate.delegateInstance()?.window = newValue }
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    SessionCookieStore.restore()
    MendixAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    clearKeychain()
    setupUI()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    SessionCookieStore.persist()
  }
}

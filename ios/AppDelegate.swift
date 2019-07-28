import Foundation
import UIKit
import MendixNative

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "Runtime url") as? String, let runTimeUrl = AppUrl.forRuntime(url: url) else {
      fatalError("Missing runtime url")
    }
    guard let bundleUrl = Bundle.main.url(forResource: "index.ios", withExtension: "bundle", subdirectory: "Bundle") else {
      fatalError("Could not load index.ios.bundle")
    }

    ReactNative.instance.start(MendixApp(bundleUrl: bundleUrl, runtimeUrl: runTimeUrl, warningsFilter: WarningsFilter.none))
    return true
  }
}

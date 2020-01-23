import Foundation
import UIKit
import MendixNative

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let targetName = Bundle.main.object(forInfoDictionaryKey: "TargetName") as? String ?? ""
    if (targetName == "dev") {
      return true
    }

    guard let url = Bundle.main.object(forInfoDictionaryKey: "Runtime url") as? String, let runTimeUrl = AppUrl.forRuntime(url: url.replacingOccurrences(of: "\\", with: "")) else {
      fatalError("Missing the 'Runtime url' configuration within the Info.plist file")
    }
    guard let bundleUrl = ReactNative.instance.getJSBundleFile() else {
      fatalError("Could not properly load JS bundle file")
    }

    ReactNative.instance.start(MendixApp(bundleUrl: bundleUrl, runtimeUrl: runTimeUrl, warningsFilter: WarningsFilter.none))
    return true
  }
}

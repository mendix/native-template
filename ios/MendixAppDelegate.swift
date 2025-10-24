import Foundation
import UIKit
import UserNotifications
import React
import MendixNative

class MendixAppDelegate: NSObject {
  
  static var delegate: (UIResponder & UIApplicationDelegate & UNUserNotificationCenterDelegate)?
  
  static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    
  }
  
  static func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
  }
  
  static func application(_ application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    
  }
  
  static func application(_ application: UIApplication, openURL url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return true
  }
  
  static func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: Any) {
    
  }
  
  static func userNotificationCenter(_ center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
  }
  
  static func userNotificationCenter(_ center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
  }
  
  static func getJSBundleFile() -> URL? {
    return BundleHelper.getJSBundleFile()
  }
}

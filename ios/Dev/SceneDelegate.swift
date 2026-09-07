import UIKit
import MendixNative

class SceneDelegate: ReactAppProvider {

  var shouldOpenInLastApp = false
  var hasHandledLaunchAppWithOptions = false

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    setUpProvider()
    IQKeyboardManager.shared().isEnabled = false

    let controller = UIStoryboard.launchApp.instantiateInitialViewController() ?? UIViewController()
    changeRoot(to: controller)
    window?.isUserInteractionEnabled = true

    if let context = connectionOptions.urlContexts.first {
      handle(url: context.url, options: openURLOptions(from: context))
    }
  }

  func getWarningFilterValue() -> WarningsFilter {
    #if DEBUG
    return .all
    #else
    return AppPreferences.devModeEnabled ? .partial : .none
    #endif
  }

  @objc func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let context = URLContexts.first else { return }
    handle(url: context.url, options: openURLOptions(from: context))
  }

  private func handle(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) {
    let handled = MendixAppDelegate.application(UIApplication.shared, openURL: url, options: options)

    let appUrl = AppPreferences.safeAppUrl

    if (!handled || appUrl.isEmpty || ReactAppProvider.isReactAppActive()) {
      return
    }

    let bundleUrl = AppUrl.forBundle(
      appUrl,
      port: AppPreferences.remoteDebuggingPackagerPort,
      isDebuggingRemotely: AppPreferences.remoteDebuggingEnabled,
      isDevModeEnabled: AppPreferences.devModeEnabled
    )

    var launchOptions: [AnyHashable: Any] = options
    launchOptions[UIApplication.LaunchOptionsKey.url] = url
    launchOptions[UIApplication.LaunchOptionsKey.annotation] = options[UIApplication.OpenURLOptionsKey.annotation] ?? []

    let mxApp = MendixApp(
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

    ReactNative.shared.setup(mxApp, launchOptions: launchOptions)
    ReactNative.shared.start()
  }

  @objc func sceneDidEnterBackground(_ scene: UIScene) {
    SessionCookieStore.persist()
  }

  static func delegateInstance() -> SceneDelegate? {
    if let provider = ReactAppProvider.shared() as? SceneDelegate {
      return provider
    }
    return UIApplication.shared.connectedScenes.compactMap { $0.delegate as? SceneDelegate }.first
  }

  private func openURLOptions(from context: UIOpenURLContext) -> [UIApplication.OpenURLOptionsKey: Any] {
    var options: [UIApplication.OpenURLOptionsKey: Any] = [.openInPlace: context.options.openInPlace]
    if let sourceApplication = context.options.sourceApplication {
      options[.sourceApplication] = sourceApplication
    }
    if let annotation = context.options.annotation {
      options[.annotation] = annotation
    }
    return options
  }
}

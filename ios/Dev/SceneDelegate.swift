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

    if !connectionOptions.urlContexts.isEmpty {
      launchMendixApp(with: ReactAppProvider.launchOptions(from: connectionOptions))
    }
  }

  func getWarningFilterValue() -> WarningsFilter {
    #if DEBUG
    return .all
    #else
    return AppPreferences.devModeEnabled ? .partial : .none
    #endif
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    handleURLContexts(URLContexts) { [weak self] launchOptions in
      self?.launchMendixApp(with: launchOptions)
    }
  }

  private func launchMendixApp(with launchOptions: [AnyHashable: Any]) {
    let appUrl = AppPreferences.safeAppUrl

    guard !appUrl.isEmpty else { return }

    let bundleUrl = AppUrl.forBundle(
      appUrl,
      port: AppPreferences.remoteDebuggingPackagerPort,
      isDebuggingRemotely: AppPreferences.remoteDebuggingEnabled,
      isDevModeEnabled: AppPreferences.devModeEnabled
    )

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

}

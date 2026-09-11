import UIKit
import MendixNative

class SceneDelegate: ReactAppProvider {

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    setUpProvider()
    changeRoot(to: UIViewController())

    let launchOptions = connectionOptions.urlContexts.isEmpty
      ? nil
      : ReactAppProvider.launchOptions(from: connectionOptions)

    guard let url = Bundle.main.object(forInfoDictionaryKey: "Runtime url") as? String, !url.isEmpty else {
      showUnrecoverableDialog(
        title: "The runtime URL is missing",
        message: "Missing the 'Runtime url' configuration within the Info.plist file. The app will close."
      )
      return
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
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let context = URLContexts.first else { return }
    MendixAppDelegate.application(
      UIApplication.shared,
      openURL: context.url,
      options: openURLOptions(from: context)
    )
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

  private func showUnrecoverableDialog(title: String, message: String) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(.init(title: "Close", style: .default, handler: {_ in
      print(message)
      exit(0)
    }))
    window?.rootViewController?.present(controller, animated: true, completion: nil)
  }
}

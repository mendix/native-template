import UIKit
import MendixNative

class LaunchAppViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearDataSwitch: UISwitch!

    private var uiState: State = .idle {
        didSet {
            if (oldValue != uiState) {
                updateUIState()
            }
        }
    }

    func launchApp(_ url: String) {
        AppPreferences.setAppUrl(url: url)
        AppPreferences.remoteDebugging(enable: false)
        AppPreferences.devMode(enable:  true)
        self.performSegue(withIdentifier: "MendixApp", sender: nil)
    }

    @IBAction func unFocusTextField(_ sender: Any) {
        textField.resignFirstResponder()
    }

    @IBAction func onTapGo(_ sender: Any) {
        if (uiState == .loading) {
            return;
        }

        uiState = .loading
        validateMendixUrl(textField.text ?? "") { (running) in
            guard running, let url = self.textField.text, AppUrl.isValid(url: url) else {
                self.uiState = .invalidInput
                return
            }
            self.textField.resignFirstResponder()
            self.uiState = .idle
            self.launchApp(url)
        }
    }

    override func viewDidLayoutSubviews() {
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiState = .idle
        textField.text = AppPreferences.getAppUrl()
        registerNotificationObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotificationObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.layer.cornerRadius = 30
        if let placeHolderText = textField.placeholder {
          textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mendixAppVC = segue.destination as? MendixAppViewController {
          let url = AppUrl.forBundle(
            url: AppPreferences.getAppUrl(),
            remoteDebuggingPackagerPort: AppPreferences.getRemoteDebuggingPackagerPort(),
            isDebuggingRemotely: AppPreferences.remoteDebuggingEnabled(),
            isDevModeEnabled: AppPreferences.devModeEnabled())

          let runtimeUrl: URL = AppUrl.forRuntime(url: AppPreferences.getAppUrl())!

          mendixAppVC.setupMendixApp(MendixApp(bundleUrl: url!, runtimeUrl: runtimeUrl, warningsFilter: getWarningFilterValue(), enableGestures: true, clearDataAtLaunch: clearDataSwitch.isOn))
        }
    }
}

private let KEYBOARD_ANIMATION_DURATION_IN_S = 0.25
private let KEYBOARD_SHOW_ANIMATION_DEBOUNCE_TIME_IN_S = 0.01

private var keyboardShowTask: DispatchWorkItem?

extension LaunchAppViewController {
    private func getWarningFilterValue() -> WarningsFilter {
#if DEBUG
        return WarningsFilter.all
#else
        return (AppPreferences.devModeEnabled() ? WarningsFilter.partial : WarningsFilter.none)
#endif
    }

    private func validateMendixUrl(_ urlString: String, onCompletion: @escaping (_ valid: Bool) -> Void) {
        if let url = AppUrl.forValidation(url: urlString) {
            URLValidator.validate(url, onCompletion: onCompletion)
            return
        }

        onCompletion(false)
    }

    private func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    private func unregisterNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardShowTask?.cancel()
        keyboardShowTask = DispatchWorkItem {
            if let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
                self.view.frame.size.height = UIScreen.main.bounds.height - keyboardRect.height
                UIView.animate(withDuration: duration ?? KEYBOARD_ANIMATION_DURATION_IN_S, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + KEYBOARD_SHOW_ANIMATION_DEBOUNCE_TIME_IN_S, execute: keyboardShowTask!)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        view.frame.size.height = UIScreen.main.bounds.height
        UIView.animate(withDuration: duration ?? KEYBOARD_ANIMATION_DURATION_IN_S, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private enum State {
        case idle
        case loading
        case invalidInput
        case invalidQRCode
    }

    private func updateUIState() {
        switch uiState {
        case .idle:
            textField.layer.opacity = 1
            break
        case .loading:
            textField.layer.opacity = 0.5
            break
        case .invalidInput:
            textField.layer.opacity = 1
            showErrorDialog(error: "The Mendix app may not be running at the moment or its an invalid URL.")
            break;
        case .invalidQRCode:
            textField.layer.opacity = 1
            showErrorDialog(error: "This is not a Mendix QR code.")
            break
        }
    }

    private func showErrorDialog(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 16

        navigationController?.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            alert.dismiss(animated: true)
        }
    }
}

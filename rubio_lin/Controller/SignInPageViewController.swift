import UIKit

class SignInPageViewController: UIViewController {
    
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInPage") as! SignInPageViewController
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addKeyboardObserver()
        if rememberMeButton.isSelected {
            let userDefaults = UserDefaults.standard
            if let email = userDefaults.string(forKey: "email") {
                emailTextField.text = email
            }
        } else {
            emailTextField.text?.removeAll()
        }
        passwordTextField.text?.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmailTextField()
        setPasswordTextField()
        rememberMeButton.isSelected = true
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setEmailTextField() {
        emailTextField.keyboardType = .asciiCapable
        let overlay = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        emailTextField.setLeftView(overlay, emailTextField, NSLocalizedString("account", comment: ""), .always)
        emailTextField.setUITextField(emailTextField, 22, .white, 1.0, 1.0, UIColor.black.cgColor)
    }

    func setPasswordTextField() {
        passwordTextField.keyboardType = .asciiCapable
        let psLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        passwordTextField.setLeftView(psLeftView, passwordTextField, NSLocalizedString("password", comment: ""), .always)
        passwordTextField.setUITextField(passwordTextField, 22, .white, 1.0, 1.0, UIColor.black.cgColor)
        let psRightView = UIButton(frame: CGRect(x: 6, y: 11, width: 30, height: 22))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        isVisiblePassword(psRightView)
        psRightView.addTarget(self, action: #selector(isVisiblePassword), for: .touchUpInside)
        view.addSubview(psRightView)
        view.backgroundColor = .clear
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = view
    }
    
    @objc func isVisiblePassword(_ button: UIButton) {
        button.tintColor = .black
        if button.isSelected {
            button.isSelected = false
            self.passwordTextField.isSecureTextEntry = false
            button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            button.isSelected = true
            self.passwordTextField.isSecureTextEntry = true
            button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    @IBAction func emailEditDidEnd(_ sender: Any) {
        if rememberMeButton.isSelected == true {
            let userDefaults = UserDefaults.standard
            userDefaults.set(emailTextField.text ?? "", forKey: "email")
        }
    }
    
    @IBAction func touchdown(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func clickRememberMebutton(_ sender: UIButton) {
        if rememberMeButton.isSelected {
            rememberMeButton.isSelected = false
            rememberMeButton.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            rememberMeButton.isSelected = true
            rememberMeButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }

    @IBAction func clickOnSignIn(_ sender: UIButton) {
        let punctuation = "!@#$%^&*(),.<>;'`~[]{}\\|/?_-+="
        var message = ""
        if emailTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            message += NSLocalizedString("emailIsEmpty", comment: "")
            print("Email is empty")
        } else if emailTextField.text!.split(separator: "@")[0].count > 20 || emailTextField.text!.split(separator: "@")[0].count < 4 {
            message += NSLocalizedString("emailIncorrectWordCount", comment: "")
            print("Email incorrect word count")
        }
        
        if passwordTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            message += NSLocalizedString("passwordIsEmpty", comment: "")
            print("Password is empty")
        } else if passwordTextField.text!.count > 12 || passwordTextField.text!.count < 6 {
            message += NSLocalizedString("passwordIncorrectWordCount", comment: "")
            print("Password incorrect word count")
        }
        
        for i in punctuation {
            if passwordTextField.text?.contains(i) == true {
                message += NSLocalizedString("passwordIsBadlyFormatted", comment: "")
                print("Password is badly formatted")
                break
            }
        }
        
        if message != "" {
            showAlertInfo(message, y: self.view.bounds.midY * 0.64)
        } else {
            self.showSpinner()
            FirebaseManager.shared.signInUser(emailTextField.text!, passwordTextField.text!) { error in
                if error == nil {
                    FirebaseManager.shared.getUserInfo() // 登入使用者要抓取其UserInfo
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.viewDidLoad()
                    self.removeSpinner()
                    print("Sign In Success")
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("SignInFailure", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.removeSpinner()
                    self.present(alert, animated: true)
                    print("Sign In Failure：\(String(describing: error))")
                }
            }
        }
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        switch sender {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            self.clickOnSignIn(signInBtn)
        default:
            break
        }
    }
}

// MARK: - Setup KeyboardObserver
extension SignInPageViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            view.frame.origin.y = -keyboardHeight * 0.36
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
}

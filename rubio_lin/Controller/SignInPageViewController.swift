//
//  LoginViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit
import FirebaseAuth

class SignInPageViewController: UIViewController {
    
    static let SignInPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInPage")
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    var rememberMe: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmailTextField()
        setPasswordTextField()
        rememberMeButton.isSelected = true
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setEmailTextField() {
        let overlay = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        emailTextField.setLeftView(overlay, emailTextField, "  帳號 ", .always)
        emailTextField.setUITextField(emailTextField, 22, .white, 1.0, 1.0, UIColor.black.cgColor)
    }
    
    func setPasswordTextField() {
        let psLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        passwordTextField.setLeftView(psLeftView, passwordTextField, "  密碼 ", .always)
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
        let userDefaults = UserDefaults.standard
        userDefaults.set(emailTextField.text ?? "", forKey: "email")
    }
    @IBAction func passwordEditDidEnd(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(passwordTextField.text ?? "", forKey: "password")
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
        self.removeSpinner()
        let punctuation = "!@#$%^&*(),.<>;'`~[]{}\\|/?_-+="
        var email = ""
        var password = ""
        var message = ""
        if emailTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            message += "請輸入帳號 "
            print("Email is empty")
        } else if emailTextField.text!.split(separator: "@")[0].count >= 20 || emailTextField.text!.split(separator: "@")[0].count <= 4 {
            message += "帳號字數不正確 "
            print("Email incorrect word count")
        } else if punctuation.contains(emailTextField.text!.split(separator: "@")[0]) {
            message += "帳號含有特殊符號 "
            print("Email is badly formatted")
        } else {
            email = emailTextField.text!
        }
        if passwordTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            message += "請輸入密碼"
            print("Password is empty")
        } else if passwordTextField.text!.count >= 12 || passwordTextField.text!.count <= 6 {
            message += "密碼字數不正確"
            print("Password incorrect word count")
        } else if punctuation.contains(passwordTextField.text!) {
            message += "密碼含有特殊符號"
            print("Password is badly formatted")
        } else {
            password = passwordTextField.text!
        }
        if message != "" {
            showAlertInfo(message)
        }
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard let user = result?.user, error == nil else {
                    let alert = UIAlertController(title: "Sign in failure", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                    print(error?.localizedDescription)
                    return
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func clinkOnSignUp(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignUpPageViewController.SignUpPage, animated: true)
    }
}

extension SignInPageViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height / 2
            view.bounds.origin.y = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
            view.bounds.origin.y = 0
        }
    
}

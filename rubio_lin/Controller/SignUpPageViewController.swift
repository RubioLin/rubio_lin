import UIKit


class SignUpPageViewController: UIViewController {
    
    static let SignUpPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPage") as! SignUpPageViewController
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setNavigationBar()
        setEmailTextField()
        setPasswordTextField()
        setNicknameTextField()
        setHeadPhotoImageView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    func setNavigationBar() {
        let navigationBarLeftButton = UIBarButtonItem(image: UIImage(named: "titlebarBack"), style: .plain, target: self, action: #selector(backPreviousPage))
        navigationBarLeftButton.tintColor = UIColor.black
        self.navigationItem.title = NSLocalizedString("signUpPageNavigationTitle", comment: "")
        self.navigationItem.setLeftBarButton(navigationBarLeftButton, animated: true)
    }
    
    @objc func backPreviousPage() {
        self.navigationController?.popViewController(animated: true)
        self.nicknameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.userHeadPhotoImageView.image = UIImage(named: "picPersonal")
    }
    
    func setNicknameTextField() {
        let overlay = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        nicknameTextField.setLeftView(overlay, nicknameTextField, NSLocalizedString("nickname", comment: ""), .always)
        nicknameTextField.setUITextField(nicknameTextField, 22, UIColor.white, 1, 1, UIColor.black.cgColor)
    }
    
    func setEmailTextField() {
        emailTextField.keyboardType = .asciiCapable
        let overlay = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        emailTextField.setLeftView(overlay, emailTextField, NSLocalizedString("account", comment: ""), .always)
        emailTextField.setUITextField(emailTextField, 22, UIColor.white, 1, 1, UIColor.black.cgColor)
    }
    
    func setPasswordTextField() {
        passwordTextField.keyboardType = .asciiCapable
        let psLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        passwordTextField.setLeftView(psLeftView, passwordTextField, NSLocalizedString("password", comment: ""), .always)
        passwordTextField.setUITextField(passwordTextField, 22, UIColor.white, 1, 1, UIColor.black.cgColor)
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
    
    func setHeadPhotoImageView() {
        let userHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        userHeadPhotoImageView.layer.cornerRadius = userHeadPhotoCornerRadius
    }
    
    // 點螢幕會自動收鍵盤
    @IBAction func touchDown(_ sender: Any) {
        nicknameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let sources:[(name:String, type:UIImagePickerController.SourceType)] = [
            (NSLocalizedString("selectedPhoto", comment: ""), .photoLibrary),
            (NSLocalizedString("openCamera", comment: ""), .camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { (_) in
                self.selectPhoto(sourceType: source.type)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clickOnSignUp(_ sender: Any) {
        var message = ""
        let punctuation = "!@#$%^&*(),.<>;'`~[]{}\\|/?_-+="
        if nicknameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            message += NSLocalizedString("nicknameIsEmpty", comment: "")
            print("Nickname is empty")
        }
        
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
        
        guard message == "" else {
            showAlertInfo(message, y: self.view.bounds.midY * 1.6)
            return
        }
        self.showSpinner()
        //create a new user and upload to FirebaseAuth
        if let email = emailTextField.text, let password = passwordTextField.text, let nickname = nicknameTextField.text {
            FirebaseManager.shared.signUpUser(email, password) { error in
                if error == nil {
                    FirebaseManager.shared.uploadUserAvatar(self.userHeadPhotoImageView.image!, email) { result in
                        switch result {
                        case .success(let avatarUrl):
                            FirebaseManager.shared.uploadUserInfo(nickname, email, password, avatarUrl)
                            FirebaseManager.shared.getUserInfo() // 註冊新的使用者要抓取其UserInfo
                            self.removeSpinner()
                            self.tabBarController?.selectedIndex = 0
                            self.navigationController?.viewDidLoad()
                        case .failure(let error):
                            print("使用者頭像上傳失敗")
                            print("Error：\(error.localizedDescription)")
                        }
                    }
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("SignUpFailure", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.removeSpinner()
                    self.present(alert, animated: true)
                    print("Sign Up Failure：\(String(describing: error))")
                }
            }
        }
    }
}

// MARK: - Setup UIImagePicker
extension SignUpPageViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func selectPhoto(sourceType: UIImagePickerController.SourceType) {
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.sourceType = sourceType
        ImagePickerController.delegate = self
        present(ImagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userHeadPhotoImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true,completion: nil)
    }
}

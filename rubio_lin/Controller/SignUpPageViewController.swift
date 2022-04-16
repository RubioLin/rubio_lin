//
//  SignUpViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/6.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift

let userDefaults = UserDefaults.standard

class SignUpPageViewController: UIViewController {
    
    
    static let SignUpPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPage")
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {        
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmailTextField()
        setPasswordTextField()
        setNicknameTextField()
        setNavigationBar()
        setHeadPhotoImageView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }

// MARK: - 設置畫面上的各類元件狀態
    func setNavigationBar() {
        let navigationBarLeftButton = UIBarButtonItem(image: UIImage(named: "titlebarBack"), style: .plain, target: self, action: #selector(backPreviousPage))
        navigationBarLeftButton.tintColor = UIColor.black
        self.navigationItem.title = "註冊會員"
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
        nicknameTextField.setLeftView(overlay, nicknameTextField, "  暱稱 ", .always)
        nicknameTextField.setUITextField(nicknameTextField, 22, UIColor.white, 1, 1, UIColor.black.cgColor)
    }
    
    func setEmailTextField() {
        let overlay = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        emailTextField.setLeftView(overlay, emailTextField, "  帳號 ", .always)
        emailTextField.setUITextField(emailTextField, 22, UIColor.white, 1, 1, UIColor.black.cgColor)
    }
    
    func setPasswordTextField() {
        let psLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        passwordTextField.setLeftView(psLeftView, passwordTextField, "  密碼 ", .always)
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
    
// MARK: - 點螢幕會自動收鍵盤
    @IBAction func touchDown(_ sender: Any) {
        nicknameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let sources:[(name:String, type:UIImagePickerController.SourceType)] = [
            ("Album", .photoLibrary),
            ("Camera", .camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { (_) in
                self.selectPhoto(sourceType: source.type)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clickOnSignUp(_ sender: Any) {
        var nickname = ""
        var email = ""
        var password = ""
        var message = ""
        if nicknameTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
            nickname = nicknameTextField.text!
        }
        
        do {
            try judgeInput(emailTextField)
            email = emailTextField.text!
        } catch InputError.emailcount {
             message += "帳號字數不正確 "
            print("email Incorrect Word Count")
        } catch InputError.isEmpty {
            message += "請輸入帳號 "
            print("email is Empty")
        } catch {
            print("email Other Error")
        }
        do {
            try judgeInput(passwordTextField)
            password = passwordTextField.text!
        } catch InputError.passwordcount {
            message += "密碼字數不正確 "
            print("password Incorrect Word Count")
        } catch InputError.isEmpty {
            message += "請輸入密碼 "
            print("password is Empty")
        } catch {
            print("password Other Error")
        }
        
        if message != "" {
            let alert = UIAlertController(title: "請正確輸入", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
        
        if nickname != "" && email != "" && password != "" {
        //create a new user and upload to FirebaseAuth
        createUser()
        //upload userPhoto to Storage
        uploadPhoto(image: userHeadPhotoImageView.image ?? UIImage()) { result in
                switch result {
                case .success(let userPhotoUrl):
                    //upload UserInfo to Firestore
                    self.uploadUserInfo(url: userPhotoUrl)
                    self.nicknameTextField.text = ""
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.userHeadPhotoImageView.image = UIImage(named: "picPersonal")
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { Timer in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.tabBarController?.selectedIndex = 0
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func createUser() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
                guard let user = result?.user, error == nil else {
                    let alert = UIAlertController(title: "Sign up failure", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print(error?.localizedDescription)
                    return
                }
            }
        }
    }
    
    func uploadUserInfo(url: URL) {
        if let nickname = nicknameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            guard email != "" else {
                print("email can't be nil")
                return
            }
            let user = UserInfo(nickname: nickname, email: email, password: password, userPhotoUrl: url)
            do {
                try db.collection("userInfo").document("\(email)").setData(from: user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        if let email = emailTextField.text {
            guard email != "" else {
                print("email can't be nil")
                return
            }
            let fileReference = Storage.storage().reference().child("\(email).jpg")
            if let data = image.jpegData(compressionQuality: 0.6) {
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success(_):
                        fileReference.downloadURL { result in
                            switch result {
                            case .success(let url):
                                completion(.success(url))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
}

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

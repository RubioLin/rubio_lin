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
    
    func setNavigationBar() {
        let navigationBarLeftButton = UIBarButtonItem(image: UIImage(named: "titlebarBack"), style: .plain, target: self, action: #selector(backPreviousPage))
        navigationBarLeftButton.tintColor = UIColor.black
        self.navigationItem.title = "註冊會員"
        self.navigationItem.setLeftBarButton(navigationBarLeftButton, animated: true)
    }
    
    @objc func backPreviousPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNicknameTextField() {
        let accountOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        accountOverlayLabel.text = "  暱稱 "
        nicknameTextField.leftView = accountOverlayLabel
        nicknameTextField.leftViewMode = .always
        nicknameTextField.layer.borderWidth = 1
        nicknameTextField.layer.borderColor = UIColor.black.cgColor
        nicknameTextField.layer.cornerRadius = 22
    }
    
    func setEmailTextField() {
        let accountOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        accountOverlayLabel.text = "  帳號 "
        emailTextField.leftView = accountOverlayLabel
        emailTextField.leftViewMode = .always
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.cornerRadius = 22
    }
    
    func setPasswordTextField() {
        let psLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        psLeftView.text = "  密碼 "
        passwordTextField.leftView = psLeftView
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.cornerRadius = 22
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
        //create a new user and upload to FirebaseAuth
        createUser()
        //upload userPhoto to Storage
        uploadPhoto(image: userHeadPhotoImageView.image ?? UIImage()) { result in
                switch result {
                case .success(let userPhotoUrl):
                    //upload UserInfo to Firestore
                    self.uploadUserInfo(url: userPhotoUrl)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        nicknameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        userHeadPhotoImageView.image = UIImage(named: "picPersonal")
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
                self.navigationController?.popToRootViewController(animated: true)
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

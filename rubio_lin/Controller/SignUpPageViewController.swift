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

class SignUpPageViewController: UIViewController {
    
    static let SignUpPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPage")
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    let db = Firestore.firestore()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nickNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        userHeadPhotoImageView.image = UIImage(named: "picPersonal")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmailTextField()
        setPasswordTextField()
        setNickNameTextField()
        setNavigationBar()
        setHeadPhotoImageView()
    }
    
    func setNavigationBar() {
        let navigationBarLeftButton = UIBarButtonItem(image: UIImage(named: "titlebarBack"), style: .plain, target: self, action: Selector("backPreviousPage"))
        navigationBarLeftButton.tintColor = UIColor.black
        self.navigationItem.title = "註冊會員"
        self.navigationItem.setLeftBarButton(navigationBarLeftButton, animated: true)
    }
    
    @objc func backPreviousPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNickNameTextField() {
        let accountOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        accountOverlayLabel.text = "  暱稱 "
        nickNameTextField.leftView = accountOverlayLabel
        nickNameTextField.leftViewMode = .always
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.borderColor = UIColor.black.cgColor
        nickNameTextField.layer.cornerRadius = 22
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
        let passwordOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        passwordOverlayLabel.text = "  密碼 "
        passwordTextField.leftView = passwordOverlayLabel
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.cornerRadius = 22
    }
    
    func setHeadPhotoImageView() {
        let userHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        userHeadPhotoImageView.layer.cornerRadius = userHeadPhotoCornerRadius
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
        uploadPhoto(image: userHeadPhotoImageView.image!) { result in
                switch result {
                case .success(let userPhotoUrl):
                    //upload UserInfo to Firestore
                    self.uploadUserInfo(url: userPhotoUrl)
                    print(userPhotoUrl)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            self.navigationController?.popToRootViewController(animated: true)
            }
    }
    
    func createUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] result, error in
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
    
    func uploadUserInfo(url: URL) {
        let user = UserInfo(nickName: nickNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, userPhotoUrl: url)
        do {
            try db.collection("userInfo").document(emailTextField.text!).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileReference = Storage.storage().reference().child("\(emailTextField.text!).jpg")
        if let data = image.jpegData(compressionQuality: 1) {
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

//
//  SignUpViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/6.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpPageViewController: UIViewController {
    
    static let SignUpPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPage")
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    var captureImage: UIImage?
    var userUid: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nickNameTextField.text = ""
        userNameTextField.text = ""
        passwordTextField.text = ""
        userHeadPhotoImageView.image = UIImage(named: "picPersonal")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserNameTextField()
        setPasswordTextField()
        setNickNameTextField()
        setNavigationBar()
        setHeadPhotoImageView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        uploadUserInfo()
    }
    
    // upload userInfo to Firestore
    func uploadUserInfo() {
        let db = Firestore.firestore()
        let user = UserInfo(id: "\(userUid!)", nickName: "\(nickNameTextField.text!)", email: "\(userNameTextField.text!)", passWord: "\(passwordTextField.text!)", Phoro: "")
        do {
            try db.collection("userInfo").document("\(userUid!)").setData(from: user)
            print("成功")
        } catch {
            print(error)
        }
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
    
    func setUserNameTextField() {
        let accountOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        accountOverlayLabel.text = "  帳號 "
        userNameTextField.leftView = accountOverlayLabel
        userNameTextField.leftViewMode = .always
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.borderColor = UIColor.black.cgColor
        userNameTextField.layer.cornerRadius = 22
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
        Auth.auth().createUser(withEmail: userNameTextField.text!, password: passwordTextField.text!) { [self] result, error in
            guard let user = result?.user,
                  error == nil else {
                let alert = UIAlertController(title: "Sign up failure", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                print(error?.localizedDescription)
                return
            }
            userUid = user.uid
            self.navigationController?.popToRootViewController(animated: true)
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
        captureImage = info[.originalImage] as? UIImage
        userHeadPhotoImageView.image = captureImage
        dismiss(animated: true,completion: nil)
    }
    
}

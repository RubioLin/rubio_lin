//
//  LoginViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit
import FirebaseAuth

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton : UIButton!
    var rememberMe: Bool = false
    var isSingIn: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccountTextField()
        setPasswordTextField()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
            
    func setAccountTextField() {
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
    
    @IBAction func clickRememberMebutton(_ sender: UIButton) {
        if rememberMe == false {
            rememberMe = true
            rememberMeButton .setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            rememberMe = false
            rememberMeButton .setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @IBAction func clickOnSignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

}

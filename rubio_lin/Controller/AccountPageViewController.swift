//
//  AccountViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

class AccountPageViewController: UIViewController {
    
    static let AccountPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountPage")
    @IBOutlet weak var accountHeadPhotoImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var signInOutButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("\(user.uid) login")
            } else {
                self.navigationController?.pushViewController(SignInPageViewController.SignInPage, animated: true)
                print("not login")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeadPhotoImageView()
        }
    
    func setHeadPhotoImageView() {
        let accountHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        accountHeadPhotoImageView.layer.cornerRadius = accountHeadPhotoCornerRadius
    }
    
    @IBAction func clickOnSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

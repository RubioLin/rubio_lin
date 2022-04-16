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
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInOutButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let currentUser = user {
                if let email = currentUser.email {
                    print("\(email) login")
                    self.db.collection("userInfo").document(email).getDocument { document, error in
                        guard let documents = document, documents.exists, let user = try? documents.data(as: UserInfo.self) else { return }
                        self.showSpinner()
                        URLSession.shared.dataTask(with: user.userPhotoUrl) { data, response, error in
                            DispatchQueue.main.async {
                                if let data = data {
                                    self.userHeadPhotoImageView.image = UIImage(data: data)
                                }
                                self.nickNameLabel.text = "暱稱：\(user.nickname)"
                                self.emailLabel.text = "帳號：\(user.email)"
                                self.removeSpinner()
                            }
                        }.resume()
                    }
                }
            } else {
                print("not login")
                self.navigationController?.pushViewController(SignInPageViewController.SignInPage, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeadPhotoImageView()
        self.navigationItem.title = "會員資訊"
    }
    
    func setHeadPhotoImageView() {
        let accountHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        userHeadPhotoImageView.layer.cornerRadius = accountHeadPhotoCornerRadius
    }
    
    @IBAction func clickOnSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            userHeadPhotoImageView.image = UIImage(named: "picPersonal")
            nickNameLabel.text = nil
            emailLabel.text = nil
        } catch {
            print(error)
        }
    }
}

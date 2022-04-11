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
        handle = Auth.auth().addStateDidChangeListener{ auth, user in
            if let user = user {
                if let currentUserEmail = Auth.auth().currentUser?.email {
                    self.db.collection("userInfo").document(currentUserEmail).getDocument { document, error in
                        guard let document = document, document.exists,
                              let user = try? document.data(as: UserInfo.self) else { return }
                        print(user)
                        URLSession.shared.dataTask(with: user.userPhotoUrl) { data, response, error in
                            DispatchQueue.main.async {
                                self.userHeadPhotoImageView.image = UIImage(data: data!)
                                self.nickNameLabel.text = user.nickName
                                self.emailLabel.text = user.email
                            }
                        }.resume()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("\(user.email) login")
            } else {
                self.navigationController?.pushViewController(SignInPageViewController.SignInPage, animated: true)
                print("not login")
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
    }
    
    func setHeadPhotoImageView() {
        let accountHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        userHeadPhotoImageView.layer.cornerRadius = accountHeadPhotoCornerRadius
    }
    
    @IBAction func clickOnSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

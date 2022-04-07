//
//  AccountViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit
import FirebaseAuth

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
        
        // Do any additional setup after loading the view.
        //檢查用
        //        var timer = Timer()
        //        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(a), userInfo: nil, repeats: true)
    }
    
    //    @objc func a() {
    //        if let user = Auth.auth().currentUser {
    //            print("\(user.uid) login")
    //        } else {
    //            print("not login")
    //        }
    //    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

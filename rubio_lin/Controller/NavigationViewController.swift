//
//  NavigationViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/18.
//

import UIKit
import FirebaseAuth

class NavigationViewController: UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener{ auth, user in
            if auth.currentUser != nil {
                let accountPage = self.storyboard?.instantiateViewController(withIdentifier:"AccountPage")
                self.viewControllers = [accountPage!]
            } else {
                let signInPage = self.storyboard?.instantiateViewController(withIdentifier:"SignInPage")
                self.viewControllers = [signInPage!]
            }
        }

    }
}

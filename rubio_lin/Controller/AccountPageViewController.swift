//
//  AccountViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit

class AccountPageViewController: UIViewController {
    @IBOutlet weak var accountHeadPhotoImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var isSingIn: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeadPhotoImageView()
        // Do any additional setup after loading the view.
    }
    
    func setHeadPhotoImageView() {
        let accountHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        accountHeadPhotoImageView.layer.cornerRadius = accountHeadPhotoCornerRadius
    }

    @IBAction func clickOnSignOut(_ sender: Any) {
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

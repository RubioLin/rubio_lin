import UIKit

class AccountPageViewController: UIViewController {
    
    static let AccountPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountPage") as! AccountPageViewController
    @IBOutlet weak var userHeadPhotoImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInOutButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if FirebaseManager.shared.isSignIn == true {
            if FirebaseManager.shared.userInfo != nil {
                if let url = FirebaseManager.shared.userInfo?.userPhotoUrl {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        DispatchQueue.main.async {
                            self.userHeadPhotoImageView.image = UIImage(data: data ?? Data())
                            self.nickNameLabel.text = "\(NSLocalizedString("accountPageNickname", comment: ""))\(FirebaseManager.shared.userInfo!.nickname)"
                            self.emailLabel.text = "\(NSLocalizedString("accountPageAccount", comment: ""))\(FirebaseManager.shared.userInfo!.email)"
                        }
                    }.resume()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeadPhotoImageView()
        self.navigationItem.title = NSLocalizedString("accountPageNavigationTitle", comment: "")
    }
    
    func setHeadPhotoImageView() {
        let accountHeadPhotoCornerRadius: CGFloat = UIScreen.main.bounds.width / 4
        userHeadPhotoImageView.layer.cornerRadius = accountHeadPhotoCornerRadius
    }
    
    @IBAction func clickOnSignOut(_ sender: Any) {
        FirebaseManager.shared.signOutUser()
        self.navigationController?.viewDidLoad()
    }
}


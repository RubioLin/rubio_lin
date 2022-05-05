import UIKit

class AccountPageViewController: UIViewController {
    
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountPage") as! AccountPageViewController
    
    
    @IBOutlet weak var userAvatarIV: UIImageView!
    @IBOutlet weak var userCoverIV: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInOutButton: UIButton!
    @IBOutlet weak var followListCV: UICollectionView!
    
    var streamerAvatar: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseManager.shared.followList?.FollowList.forEach{
            streamerAvatar.append($0.streamerAvatar)
        }
        print(streamerAvatar)
        super.viewWillAppear(true)
        if FirebaseManager.shared.isSignIn == true {
            if FirebaseManager.shared.userInfo != nil {
                if let url = FirebaseManager.shared.userInfo?.userPhotoUrl {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        DispatchQueue.main.async {
                            self.userAvatarIV.image = UIImage(data: data ?? Data())
                            self.nickNameLabel.text = "\(NSLocalizedString("accountPageNickname", comment: ""))\(FirebaseManager.shared.userInfo!.nickname)"
                            self.emailLabel.text = "\(NSLocalizedString("accountPageAccount", comment: ""))\(FirebaseManager.shared.userInfo!.email)"
                        }
                    }.resume()
                }
            }
        }
        followListCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserAvatarIV()
        setNavigation()
        followListCV.register(UINib(nibName: "UserFollowListCVCell", bundle: nil), forCellWithReuseIdentifier: "UserFollowListCVCell")
        followListCV.delegate = self
        followListCV.dataSource = self
//        self.navigationItem.title = NSLocalizedString("accountPageNavigationTitle", comment: "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        streamerAvatar.removeAll()
        print(streamerAvatar)
    }
    // 還需設計點擊的設定
    func setNavigation() {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        btn.tintColor = .white
        let item = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setUserAvatarIV() {
        userAvatarIV.layer.cornerRadius = userAvatarIV.frame.height / 2
    }
    
    @IBAction func clickOnSignOut(_ sender: Any) {
        FirebaseManager.shared.signOutUser()
        self.navigationController?.viewDidLoad()
    }
}

extension AccountPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.followList?.FollowList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFollowListCVCell", for: indexPath) as! UserFollowListCVCell
       
        if let url = URL(string: streamerAvatar[indexPath.row]) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,(200...201).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        cell.streamerIV.image = UIImage(named: "paopao.png")
                    }
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell.streamerIV.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell
    }

}


import UIKit

class StreamerInfomationVC: UIViewController {
    
    weak var delegate: StreamerInfomationDelegate?
    
    @IBOutlet weak var streamerView: UIView!
    @IBOutlet weak var streamerCoverIV: UIImageView!
    @IBOutlet weak var streamerNameL: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var streamerHashtagL: UILabel!
    @IBOutlet weak var streamerIntroL: UILabel!
    
    var streamerAvatar: String?
    var streamerName: String?
    var streamerTags: String?
    var streamer_id: Int?

    override func viewWillAppear(_ animated: Bool) {
        setUIAppearance()
        setFollowBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUIAppearance() {
        streamerView.layer.masksToBounds = true
        streamerView.layer.cornerRadius = streamerView.bounds.width / 16
        
        if let url = URL(string: streamerAvatar ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.streamerCoverIV.image = UIImage(data: data ?? Data())
                }
            }.resume()
        }

        streamerNameL.text = streamerName
        
        streamerHashtagL.text = "#\(streamerTags!)"
        
        streamerIntroL.text = "我在等風，也在等你\n\n外表高冷、實質聒噪"
    }
    
    func setFollowBtn() {
        followBtn.layer.cornerRadius = followBtn.bounds.height / 4
        followBtn.layer.borderWidth = 0.2
        followBtn.layer.borderColor = UIColor.gray.cgColor
        FirebaseManager.shared.followList?.FollowList.forEach{
            if $0.streamerId == streamer_id {
                followBtn.isSelected = true
                followBtn.setTitle(NSLocalizedString("followBtnisSelected", comment: ""), for: .normal)
            } else {
                followBtn.isSelected = false
                followBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
            }
        }
    }
    
    @IBAction func clickStreamFollowBtn(_ sender: Any) {
        if FirebaseManager.shared.isSignIn == true {
        switch followBtn.isSelected {
        case true:
            followBtn.isSelected = false
            followBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
            FirebaseManager.shared.deleteUserFollowList(streamer_id!, streamerName!, streamerAvatar ?? "")
            self.delegate?.followBtnUpdate(text: NSLocalizedString("followBtn", comment: ""))
        default :
            followBtn.isSelected = true
            followBtn.setTitle(NSLocalizedString("followBtnisSelected", comment: ""), for: .normal)
            FirebaseManager.shared.uploadUserFollowList(streamer_id!, streamerName!, streamerAvatar ?? "")
            WebSocketManager.shared.sendFollow()
            self.delegate?.followBtnUpdate(text: NSLocalizedString("followBtnisSelected", comment: ""))
        }
        } else {
            let alert = UIAlertController(title: NSLocalizedString("noSignIn", comment: ""), message: NSLocalizedString("noSignInDescription", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    @IBAction func touchDown(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

protocol StreamerInfomationDelegate: AnyObject {
    
    func followBtnUpdate(text: String)
}

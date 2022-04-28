import UIKit

class StreamerInfomationVC: UIViewController {
    
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StreamerInfomation") as! StreamerInfomationVC
    
//    weak var delegate: StreamerInfomationDelegate?
    
    @IBOutlet weak var streamerView: UIView!
    @IBOutlet weak var streamerCoverIV: UIImageView!
    @IBOutlet weak var streamerNameL: UILabel!
    @IBOutlet weak var streamerFollowBtn: UIButton!
    @IBOutlet weak var streamerHashtagL: UILabel!
    @IBOutlet weak var streamerIntroL: UILabel!
        
    override func viewWillAppear(_ animated: Bool) {
        setUIAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUIAppearance() {
        streamerView.layer.masksToBounds = true
        streamerView.layer.cornerRadius = streamerView.bounds.width / 16
        
        if let url = URL(string: LiveStreamRoomViewController.shared.streamerCover ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.streamerCoverIV.image = UIImage(data: data ?? Data())
                }
            }.resume()
        }

        streamerNameL.text = LiveStreamRoomViewController.shared.streamerName
        
        streamerHashtagL.text = "#\((LiveStreamRoomViewController.shared.streamertags)!)"
        
        streamerFollowBtn.layer.cornerRadius = streamerFollowBtn.bounds.height / 4
        streamerFollowBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
        streamerFollowBtn.layer.borderWidth = 0.2
        streamerFollowBtn.layer.borderColor = UIColor.gray.cgColor
        
        streamerIntroL.text = "我在等風，也在等你\n\n外表高冷、實質聒噪"
    }
    
    @IBAction func clickStreamFollowBtn(_ sender: Any) {
        WebSocketManager.shared.sendFollow()
        switch streamerFollowBtn.isSelected {
        case true:
            streamerFollowBtn.isSelected = false
            streamerFollowBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
        default :
            streamerFollowBtn.isSelected = true
            streamerFollowBtn.setTitle(NSLocalizedString("followBtnisSelected", comment: ""), for: .normal)
        }
    }
    
    @IBAction func touchDown(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
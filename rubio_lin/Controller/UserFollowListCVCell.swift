import UIKit

class UserFollowListCVCell: UICollectionViewCell {
    
    @IBOutlet weak var streamerIV: UIImageView!
    
    override func awakeFromNib() {
        setStreamerIV()
        super.awakeFromNib()
    }
    func setStreamerIV() {
        streamerIV.layer.masksToBounds = true
        streamerIV.layer.cornerRadius = streamerIV.frame.height / 2
    }

}

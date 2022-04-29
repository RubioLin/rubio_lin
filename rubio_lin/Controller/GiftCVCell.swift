import UIKit

class GiftCVCell: UICollectionViewCell {

    @IBOutlet weak var giftPicIV: UIImageView!
    @IBOutlet weak var giftNameL: UILabel!
    @IBOutlet weak var giftPriceL: UILabel!
    
    override func awakeFromNib() {

        super.awakeFromNib()
    }
    // Cell被選取背景色會改變
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = UIColor(named: "Giftbackground")
            } else {
                self.backgroundColor = .white
            }
        }
    }

}

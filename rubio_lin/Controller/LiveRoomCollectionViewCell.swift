//
//  LiveRoomCollectionViewCell.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit

class LiveRoomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var online_numvView: UIView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var head_photoImageView: UIImageView!
    @IBOutlet weak var stream_titleLabel: UILabel!
    @IBOutlet weak var online_numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        setTagsLabel()
        setOnlineNumView()
    }
    
    override func prepareForReuse() {
        tagsLabel.isHidden = false
        online_numLabel.text?.removeAll()
        tagsLabel.text?.removeAll()
        stream_titleLabel.text?.removeAll()
        head_photoImageView.image = nil
    }
    
    func setTagsLabel() {
        tagsLabel.backgroundColor = .black
        tagsLabel.alpha = 0.8
        tagsLabel.layer.masksToBounds = true
        tagsLabel.layer.cornerRadius = 5
    }
    
    func setOnlineNumView() {
        online_numvView.layer.masksToBounds = true
        online_numvView.layer.cornerRadius = 10
    }
    
    func setCellGradient() {
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.gradientView.frame
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

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
        setStream_titleLabel()
    }
    
    override func prepareForReuse() {
        tagsLabel.isHidden = false
        online_numLabel.text?.removeAll()
        tagsLabel.text?.removeAll()
        stream_titleLabel.text?.removeAll()
        head_photoImageView.image = nil
    }
    
    func setStream_titleLabel() {
        tagsLabel.backgroundColor = .black
        tagsLabel.alpha = 0.6
        stream_titleLabel.layer.masksToBounds = true
        stream_titleLabel.layer.cornerRadius = 5
    }
        
    func setTagsLabel() {
        tagsLabel.backgroundColor = .black
        tagsLabel.alpha = 0.6
        tagsLabel.layer.masksToBounds = true
        tagsLabel.layer.cornerRadius = 5
    }
    
    func setOnlineNumView() {
        online_numvView.layer.masksToBounds = true
        online_numvView.layer.cornerRadius = 5
    }
    
//    func setCellGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = head_photoImageView.bounds
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: head_photoImageView.bounds.width, height: head_photoImageView.bounds.height)
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        self.contentView.layer.insertSublayer(gradientLayer, above: head_photoImageView.layer)
//    }
}

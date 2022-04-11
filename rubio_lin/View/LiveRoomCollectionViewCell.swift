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
        setTagsLabel()
        setOnlineNumView()
    }
    //由於reuse機制，避免照片重複顯示，所以要先將ImageView
    override func prepareForReuse() {
        online_numLabel.text = nil
        tagsLabel.text = nil
        stream_titleLabel.text = nil
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
}

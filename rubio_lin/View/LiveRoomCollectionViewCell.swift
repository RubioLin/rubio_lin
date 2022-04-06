//
//  LiveRoomCollectionViewCell.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit

class LiveRoomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var head_photoImageView: UIImageView!
    @IBOutlet weak var stream_titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //由於reuse機制，避免照片重複顯示，所以要先將ImageView
    override func prepareForReuse() {
        tagsLabel.text = nil
        stream_titleLabel.text = nil
        head_photoImageView.image = nil
        
    }

}

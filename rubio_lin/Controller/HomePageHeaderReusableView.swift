//
//  HomePageHeaderReusableView.swift
//  rubio_lin
//
//  Created by Class on 2022/4/15.
//

import UIKit

class HomePageHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var currentUserHeadPhotoImageView: UIImageView!
    @IBOutlet weak var currentUserNicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCurrentUserHeadPhotoImageView()
    }
    
    func setCurrentUserHeadPhotoImageView() {
        currentUserHeadPhotoImageView.layer.cornerRadius = currentUserHeadPhotoImageView.bounds.height / 2
        currentUserHeadPhotoImageView.contentMode = .scaleAspectFill
    }
}

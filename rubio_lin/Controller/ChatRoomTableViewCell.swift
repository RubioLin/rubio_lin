//
//  ChatRoomTableViewCell.swift
//  rubio_lin
//
//  Created by Class on 2022/4/12.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var chatTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setChatTextView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChatTextView() {
        chatTextView.alpha = 0.8
        chatTextView.layer.masksToBounds = true
        chatTextView.layer.cornerRadius = (self.frame.height - 6) / 2
        
    }
}

//
//  ChatRoomViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/11.
//

import UIKit

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSendButton()
        setChatTextField()
    }
    
    func setSendButton() {
        sendButton.layer.cornerRadius = 22
        sendButton.backgroundColor = .black
        sendButton.alpha = 0.8
    }
    func setChatTextField() {
        let chatOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        chatOverlayLabel.text = "   "
        chatTextField.leftView = chatOverlayLabel
        chatTextField.leftViewMode = .always
        chatTextField.layer.cornerRadius = 22
        chatTextField.backgroundColor = .black
        chatTextField.alpha = 0.8
        chatTextField.attributedPlaceholder = NSAttributedString(
            string: " 一起聊個天吧...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
}

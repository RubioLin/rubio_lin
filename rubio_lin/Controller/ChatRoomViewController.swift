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
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SwiftWebSocketClient.shared.establishConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ChatRoomTableViewCell", bundle: nil)
        self.chatRoomTableView.register(nib, forCellReuseIdentifier: "ChatRoomTableViewCell")
        setSendButton()
        setChatTextField()
    }
    
    func setSendButton() {
        sendButton.layer.cornerRadius = 22
        sendButton.backgroundColor = .black
        sendButton.alpha = 0.7
        
    }
    func setChatTextField() {
        let chatOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        chatOverlayLabel.text = "   "
        chatTextField.leftView = chatOverlayLabel
        chatTextField.leftViewMode = .always
        chatTextField.layer.cornerRadius = 22
        chatTextField.backgroundColor = .black
        chatTextField.alpha = 0.7
        chatTextField.attributedPlaceholder = NSAttributedString(
            string: " 一起聊個天吧...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    @IBAction func clickSendMessage(_ sender: Any) {
        SwiftWebSocketClient.shared.send(message: chatTextField.text!)
        chatTextField.text = nil
    }
    
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
//        if receiveInfo.event.contains("sys_updateRoomStatus") {
//        } else if receiveInfo.event.contains("admin_all_broadcast") {
//        } else if receiveInfo.event.contains("default_message") {
//        } else if receiveInfo.event.contains("sys_member_notice") {
//        }
        return cell
    }
    
}

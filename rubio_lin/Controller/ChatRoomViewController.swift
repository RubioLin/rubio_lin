import UIKit
import Foundation

class ChatRoomViewController: UIViewController {
    
//    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomViewController
//    @IBOutlet weak var chatTextField: UITextField!
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var chatRoomTableView: UITableView!
    var animator = UIViewPropertyAnimator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        WebSocketManager.shared.establishConnection()
//        addKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.alpha = 0.7
//        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
//            self.view.alpha = 0.4
//        }, completion: { UIViewAnimatingPosition in
//        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: "ChatRoomTableViewCell", bundle: nil)
//        self.chatRoomTableView.register(nib, forCellReuseIdentifier: "ChatRoomTableViewCell")
//        setSendButton()
//        setChatTextField()
//        WebSocketManager.shared.delegate = self
//        chatRoomTableView.allowsSelection = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        chatTextField.text?.removeAll()
//        chatRoomTableView.reloadData()
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    func setSendButton() {
//        sendButton.layer.cornerRadius = 22
//        sendButton.backgroundColor = .black
//        sendButton.alpha = 0.7
//    }
//    
//    func setChatTextField() {
//        let chatOverlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
//        chatOverlayLabel.text = "   "
//        chatTextField.leftView = chatOverlayLabel
//        chatTextField.leftViewMode = .always
//        chatTextField.setUITextField(chatTextField, 22, .black, 0.7, 0, UIColor.white.cgColor)
//        chatTextField.attributedPlaceholder = NSAttributedString(
//            string: NSLocalizedString("chatPlaceholder", comment: ""),
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        chatTextField.rightViewMode = .always
//        chatTextField.rightView = self.sendButton
//    }
//
//    @IBAction func clickSendMessage(_ sender: UIButton) {
//        if chatTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
//            self.showAlertInfo("請輸入內容", y: self.view.bounds.midY)
//            print("Input is empty")
//        } else {
//            WebSocketManager.shared.send(chatTextField.text!)
//        }
//        chatTextField.text?.removeAll() //送出後要重置輸入框
//    }
    
    // 按下return關閉鍵盤
//    @IBAction func didEndOnExit(_ sender: Any) {
//    }
    
    // 聊天室淡出，點擊聊天框變回來
//    @IBAction func editdidEnd(_ sender: Any) {
//        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
//            self.view.alpha = 0.4
//        }, completion: { UIViewAnimatingPosition in
//        })
//    }
//    @IBAction func touchdown(_ sender: Any) {
//        animator.stopAnimation(true)
//        self.view.alpha = 0.7
//    }
}

//// MARK: - 設定TableViewCell數量和內容
//extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return webSocketReceive.count
//        return WebSocketManager.shared.webSocketReceive.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
//        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//        let index = WebSocketManager.shared.webSocketReceive.count - 1 - indexPath.row
//
//        if WebSocketManager.shared.webSocketReceive[index].event.contains("sys_updateRoomStatus") {
//            if WebSocketManager.shared.webSocketReceive[index].body.entry_notice?.action == "enter" {
//                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(WebSocketManager.shared.webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemEnter", comment: ""))"
//            } else {
//                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(WebSocketManager.shared.webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemLeave", comment: ""))"
//            }
//        } else if WebSocketManager.shared.webSocketReceive[index].event.contains("default_message") {
//            cell.chatTextView.text = "\(WebSocketManager.shared.webSocketReceive[index].body.nickname!)： \(WebSocketManager.shared.webSocketReceive[index].body.text!)"
//        } else if WebSocketManager.shared.webSocketReceive[index].event.contains("admin_all_broadcast") {
//            cell.chatTextView.text = "\(NSLocalizedString("admin_all_broadcast", comment: ""))"
//        }
//        return cell
//    }
//}

// MARK: - 鍵盤事件處理
//extension ChatRoomViewController {
//    func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            self.view.frame.origin.y = -keyboardHeight + 20
//        }
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        self.view.frame.origin.y = 0
//    }
//}

//extension ChatRoomViewController: WebSocketManagerDelegate {
//    
//    func receiveFinishReload() {
//        self.chatRoomTableView.reloadData()
//        if WebSocketManager.shared.webSocketReceive.count > 0 {
//            self.chatRoomTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
//        }
//    }
//
//}

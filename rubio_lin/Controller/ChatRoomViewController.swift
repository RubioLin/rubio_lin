import UIKit
import Foundation

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatRoomTableView: UITableView!
    var webSocketTask: URLSessionWebSocketTask?
    var webSocketReceive: [receiveInfo] = []
    var animator = UIViewPropertyAnimator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        establishConnection()
        addKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.alpha = 0.7
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
            self.view.alpha = 0.4
        }, completion: { UIViewAnimatingPosition in
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ChatRoomTableViewCell", bundle: nil)
        self.chatRoomTableView.register(nib, forCellReuseIdentifier: "ChatRoomTableViewCell")
        setSendButton()
        setChatTextField()
        chatRoomTableView.allowsSelection = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        chatTextField.text?.removeAll()
        webSocketReceive.removeAll()
        chatRoomTableView.reloadData()
        disconnect()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: - WebSocket Manager
    // Establish onnection y sign in status
    func establishConnection() {
        var nickname = ""
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if FirebaseManager.shared.isSignIn == true {
            if let userInfo = FirebaseManager.shared.userInfo {
                nickname = userInfo.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                guard let url = URL(string: "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname)") else {
                    print("connection error")
                    return
                }
                let request = URLRequest(url: url)
                self.webSocketTask = urlSession.webSocketTask(with: request)
                self.webSocketTask?.resume()
                self.receive()
            }
        } else {
            nickname = NSLocalizedString("guest", comment: "")
            let urlStr = "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlStr!) else {
                print("connection error")
                return }
            let request = URLRequest(url: url)
            self.webSocketTask = urlSession.webSocketTask(with: request)
            self.webSocketTask?.resume()
            self.receive()
        }
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self]result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    do {
                        let decoder = JSONDecoder()
                        let receiveInfo = try decoder.decode(receiveInfo.self, from: Data(text.utf8))
                        if receiveInfo.event.contains("sys_updateRoomStatus") {
                            self!.webSocketReceive.append(receiveInfo)
                        } else if receiveInfo.event.contains("admin_all_broadcast") {
                            self!.webSocketReceive.append(receiveInfo)
                        } else if receiveInfo.event.contains("default_message") {
                            self!.webSocketReceive.append(receiveInfo)
                        } else if receiveInfo.event.contains("sys_member_notice") {
                        }
                    } catch {
                        print("error: \(error)")
                    }
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                default:
                    fatalError()
                }
            case .failure(let error):
                print(error)
            }
            //缺少 監聽判斷我正在往上滾，就算有新訊息進來也不能回到最下面
            self?.chatRoomTableView.reloadData()
            if self?.webSocketReceive.count ?? 1 > 0 {
                self?.chatRoomTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
            }
            self?.receive()
        }
    }
    
    func send() {
        guard let inputText = chatTextField.text else { return }
        let message = URLSessionWebSocketTask.Message.string("{\"action\": \"N\", \"content\": \"\(inputText)\"}")
        webSocketTask?.send(message) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
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
        chatTextField.setUITextField(chatTextField, 22, .black, 0.7, 0, UIColor.white.cgColor)
        chatTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("chatPlaceholder", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
   
    @IBAction func clickSendMessage(_ sender: UIButton) {
        if chatTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertInfo("請輸入內容", y: self.view.bounds.midY)
            print("Input is empty")
        } else {
            send()
        }
        chatTextField.text?.removeAll() //送出後要重置輸入框
    }
    
    // 按下return關閉鍵盤
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
    // 聊天室淡出，點擊聊天框變回來
    @IBAction func editdidEnd(_ sender: Any) {
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
            self.view.alpha = 0.4
        }, completion: { UIViewAnimatingPosition in
        })
    }
    @IBAction func touchdown(_ sender: Any) {
        animator.stopAnimation(true)
        self.view.alpha = 0.7
    }
}

// MARK: - 設定TableViewCell數量和內容
extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSocketReceive.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        let index = webSocketReceive.count - 1 - indexPath.row
       
        if webSocketReceive[index].event.contains("sys_updateRoomStatus") {
            if webSocketReceive[index].body.entry_notice?.action == "enter" {
                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemEnter", comment: ""))"
            } else {
                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemLeave", comment: ""))"
            }
        } else if webSocketReceive[index].event.contains("default_message") {
            cell.chatTextView.text = "\(webSocketReceive[index].body.nickname!)： \(webSocketReceive[index].body.text!)"
        } else if webSocketReceive[index].event.contains("admin_all_broadcast") {
            cell.chatTextView.text = "\(NSLocalizedString("admin_all_broadcast", comment: ""))"
        }
        return cell
    }
}

// MARK: - Websocket連線、離線通知
extension ChatRoomViewController: URLSessionWebSocketDelegate {
    
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask is connected")
    }
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        let reasonString: String
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            reasonString = string
        } else {
            reasonString = ""
        }
        print("URLSessionWebSocketTask is closed: code=\(closeCode), reason=\(reasonString)")
    }
}

// MARK: - 鍵盤事件處理
extension ChatRoomViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 20
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
}

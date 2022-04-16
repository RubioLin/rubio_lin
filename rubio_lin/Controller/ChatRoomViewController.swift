//
//  ChatRoomViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/11.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift



class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatRoomTableView: UITableView!
    var webSocketTask: URLSessionWebSocketTask?
    var webSocketReceive: [receiveInfo] = []
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
        }
        establishConnection()
        addKeyboardObserver()
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
        Auth.auth().removeStateDidChangeListener(handle!)
        webSocketReceive.removeAll()
        chatRoomTableView.reloadData()
        disconnect()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func establishConnection() {
        var nickname: String?
        if let currentUser = Auth.auth().currentUser {
            if let currentEmail = currentUser.email {
                self.db.collection("userInfo").document(currentEmail).getDocument { snapshots, error in
                    guard let snapshot = snapshots, snapshots!.exists, let user = try? snapshots!.data(as: UserInfo.self) else { return }
                    nickname = user.nickname
                    let urlStr = "wss://lott-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    guard let url = URL(string: urlStr!) else {
                        print("connection error")
                        return }
                    let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
                    let request = URLRequest(url: url)
                    self.webSocketTask = urlSession.webSocketTask(with: request)
                    self.webSocketTask?.resume()
                }
            }
        } else {
            nickname = "訪客"
            let urlStr = "wss://lott-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlStr!) else {
                print("connection error")
                return }
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let request = URLRequest(url: url)
            self.webSocketTask = urlSession.webSocketTask(with: request)
            self.webSocketTask?.resume()
        }
        receive()
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
                self?.chatRoomTableView.scrollToRow(at: IndexPath(row: self!.webSocketReceive.count - 1, section: 0), at: .bottom, animated: true)
            }
            self?.receive()
        }
    }
    
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string("{\"action\": \"N\", \"content\": \"\(message)\"}")
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
            string: " 一起聊個天吧...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
    }
   
    
    @IBAction func clickSendMessage(_ sender: Any) {
        do {
            try judgeInput(chatTextField)
            send(message: self.chatTextField.text!)
            print("Input is correct")
        } catch InputError.isEmpty {
            print("Input is empty")
        } catch {
            print("chat box Other error")
        }
        chatTextField.text?.removeAll() //送出後要重置輸入框
    }
    
    // 按下return關閉鍵盤
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}

// MARK: - 設定TableViewCell數量和內容
extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSocketReceive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
//        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        if webSocketReceive[indexPath.row].event.contains("sys_updateRoomStatus") {
            if webSocketReceive[indexPath.row].body.entry_notice?.action == "enter" {
                cell.chatTextView.text = "\(webSocketReceive[indexPath.row].body.entry_notice!.username!)  進入聊天室"
            } else {
                cell.chatTextView.text = "\(webSocketReceive[indexPath.row].body.entry_notice!.username!)  離開聊天室"
            }
        } else if webSocketReceive[indexPath.row].event.contains("default_message") {
            cell.chatTextView.text = "\(webSocketReceive[indexPath.row].body.nickname!): \(webSocketReceive[indexPath.row].body.text!)"
        } else if webSocketReceive[indexPath.row].event.contains("admin_all_broadcast") {
            cell.chatTextView.text = "\(webSocketReceive[indexPath.row].body.content!.tw!)"
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
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
   
}

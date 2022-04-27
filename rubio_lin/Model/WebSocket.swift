import Foundation
import UIKit

// MARK: - Websocket Modal
struct receiveInfo: Codable {
    let event: String
    let room_id: String
    let sender_role: Int
    let body: receive_body
    let time: String
}

struct receive_body: Codable {
    let nickname: String?
    let text: String?
    let type: String?
    let entry_notice: body_entry_notice?
    let content: body_content?
}

struct body_entry_notice: Codable {
    let username: String?
    let action: String?
}

struct body_content: Codable {
    let cn: String?
    let en: String?
    let tw: String?
}

// MARK: - WebSocket Manager
final class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    
    static let shared = WebSocketManager()
    
    weak var delegate: WebSocketManagerDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var request: URLRequest?
    var webSocketReceive: [receiveInfo] = []
    
    func establishConnection() {
        var nickname = ""
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if FirebaseManager.shared.isSignIn == true {
            if let userInfo = FirebaseManager.shared.userInfo {
                nickname = userInfo.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                guard let url = URL(string: "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                    print("connection error")
                    return }
                request = URLRequest(url: url)
                self.webSocketTask = urlSession.webSocketTask(with: request!)
                self.webSocketTask?.resume()
                self.receive()
            }
        } else {
            nickname = "訪客"
            guard let url = URL(string: "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                print("connection error")
                return }
            request = URLRequest(url: url)
            self.webSocketTask = urlSession.webSocketTask(with: request!)
            self.webSocketTask?.resume()
            self.receive()
        }
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    do {
                        let decoder = JSONDecoder()
                        let receiveInfo = try decoder.decode(receiveInfo.self, from: Data(text.utf8))
                        self!.webSocketReceive.append(receiveInfo)
                    } catch {
                        print("Error: \(error)")
                    }
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            self?.delegate?.receiveFinishReload()
            self?.receive()
        }
    }
    
    func disconnection() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketReceive.removeAll()
    }
    
    func send(_ inputText: String) {
        let message = URLSessionWebSocketTask.Message.string("{\"action\": \"N\", \"content\": \"\(inputText)\"}")
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error：\(error)")
            }
        }
    }
    
    func sendFollow() {
        switch LiveStreamRoomViewController.LiveStreamRoom.followBtn.isSelected {
        case true:
            break
        default:
            webSocketTask?.send(URLSessionWebSocketTask.Message.string("{\"action\": \"N\", \"content\": \"追蹤了主播❤️❤️\"}"), completionHandler: { error in
                if let error = error {
                    print(error)
                }
            })
        }
    }
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

protocol WebSocketManagerDelegate: NSObject {
    
    func receiveFinishReload()
    
}

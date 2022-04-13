//
//  WebSocket.swift
//  rubio_lin
//
//  Created by Class on 2022/4/12.
//

import Foundation

final class SwiftWebSocketClient: NSObject {

    
    static let shared = SwiftWebSocketClient()
    var webSocketTask: URLSessionWebSocketTask?
    var webSocketReceive: [receiveInfo] = []
    
    func establishConnection() {
        guard let url = URL(string: "wss://lott-dev.lottcube.asia/ws/chat/chat:app_test?nickname=Rubio") else {
            print("connection error")
            return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        webSocketTask = urlSession.webSocketTask(with: request)
        receive()
        webSocketTask?.resume()
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
                        } else if receiveInfo.event.contains("admin_all_broadcast") {
                        } else if receiveInfo.event.contains("default_message") {
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
}

extension SwiftWebSocketClient: URLSessionWebSocketDelegate {

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

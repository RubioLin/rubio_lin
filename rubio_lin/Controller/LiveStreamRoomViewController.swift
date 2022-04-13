//
//  LiveStramRoomViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/10.
//

import UIKit
import AVFoundation

class LiveStreamRoomViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var chatRoomUIView: UIView!
    static let LiveStreamRoom = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamRoom")
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var receiveInfo: receiveInfo?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chatRoomUIView.isHidden = false
        playVedio()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogOutButton()
    }

// MARK: - alert待優化
//    func setAlert() {
//        let alertWidth = UIScreen.main.bounds.width * 0.8
//        let alertHeight = alertWidth * 0.75
//        let alert = UIView(frame: CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight))
//        alert.backgroundColor = UIColor.systemGray
//        alert.layer.cornerRadius = 55
//        self.view.addSubview(alert)
//        alert.translatesAutoresizingMaskIntoConstraints = false
//        alert.center = view.center
//        print(alertWidth, alertHeight, alert.center)
//
//        let alertImage = UIImageView(frame: CGRect(x: 1, y: 1, width: 50, height: 50))
//        alertImage.image = UIImage(named: "brokenHeart")
//        alert.addSubview(alertImage)
//    }
    
    func playVedio() {
        let vedioUrl = Bundle.main.url(forResource: "hime3", withExtension: "mp4")
        player = AVPlayer(url: vedioUrl!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        self.view.layer.insertSublayer(playerLayer, at: 0)
        player.play()
        //重複播放
        let resetPlayer = {
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        let playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notification in
            resetPlayer()
        }
    }
    
    func setLogOutButton() {
        logoutButton.layer.cornerRadius = 22
        logoutButton.backgroundColor = .black
        logoutButton.alpha = 0.7
    }
    
    func setAlert() {
        let alert = UIAlertController(title: "", message: "確定離開此聊天室？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "立馬走", style: .default, handler: { UIAlertAction in
            SwiftWebSocketClient.shared.disconnect()
            self.playerLayer.removeFromSuperlayer()
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "先不要", style: .cancel, handler: { UIAlertAction in
            self.chatRoomUIView.isHidden = false
        }))
        present(alert, animated: true)
    }
    @IBAction func clickLogoutButton(_ sender: Any) {
        setAlert()
        if chatRoomUIView.isHidden == false {
            chatRoomUIView.isHidden = true
        }
    }
}

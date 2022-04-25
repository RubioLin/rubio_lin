import UIKit
import AVFoundation
import YouTubeiOSPlayerHelper

class LiveStreamRoomViewController: UIViewController, YTPlayerViewDelegate {
    
    
    static let LiveStreamRoom = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamRoom") as! LiveStreamRoomViewController
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var chatRoomUIView: UIView!
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertExitBtn: UIButton!
    @IBOutlet weak var alertStayBtn: UIButton!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let YTPlayer = YTPlayerView()
    var playlist = ["I3440shDJYw", "xSbeUixi22o", "3OHT350Acj4", "_zvMspsjNgA", "tH4SMx_-5As"]
    var isStream: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chatRoomUIView.isHidden = false
        if isStream == true {
            playerViewDidBecomeReady(YTPlayer) // 進入畫面 loading 完會自動播放
            playerView(YTPlayer, didChangeTo: .ended) // 播完會自動重播
            playVedio(playid: playlist.randomElement()!) // 隨機播放playlist裡的音樂
        } else {
            playVedio()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogoutButton()
        setupAlertView()
        YTPlayer.delegate = self
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        YTPlayer.playVideo()
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        YTPlayer.playVideo()
    }
    
    //串流影片
    func playVedio(playid: String) {
        YTPlayer.frame = self.view.bounds
        // 設定 control 0：無控制條，1：有控制條
        YTPlayer.load(withVideoId: playid, playerVars: ["controls": 0])
//        YTPlayer.webView?.configuration.allowsInlineMediaPlayback = true
        YTPlayer.isUserInteractionEnabled = false // 讓畫面不可點擊就不能暫停了
        view.insertSubview(YTPlayer, at: 0)
    }
    
    //本地影片
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
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notification in
            resetPlayer()
        }
    }
    
    func setupLogoutButton() {
        logoutButton.layer.cornerRadius = 22
        logoutButton.backgroundColor = .black
        logoutButton.alpha = 0.7
    }
    
    func setupAlertView() {
        alertUIView.layer.cornerRadius = alertUIView.bounds.width / 8
    }
    
    @IBAction func clickLogoutButton(_ sender: Any) {
        alertUIView.isHidden = false
        chatRoomUIView.isHidden = true
    }
    
    @IBAction func clickExitLiveStreamRoom(_ sender: Any) {
        YTPlayer.pauseVideo()
        player.pause()
        playerLayer.removeFromSuperlayer()
        YTPlayer.removeWebView()
        alertUIView.isHidden = true
        self.dismiss(animated: true)
    }
    @IBAction func clickStayLiveStreamRoom(_ sender: Any) {
        chatRoomUIView.isHidden = false
        alertUIView.isHidden = true
    }
}

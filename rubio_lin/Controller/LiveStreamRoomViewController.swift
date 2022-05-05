import UIKit
import AVFoundation
import YouTubeiOSPlayerHelper

class LiveStreamRoomViewController: UIViewController, YTPlayerViewDelegate, URLSessionDelegate {
    
//    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamRoom") as! LiveStreamRoomViewController
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertExitBtn: UIButton!
    @IBOutlet weak var alertStayBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var streamInfoAndFollowBtnBackgroundView: UIView!
    @IBOutlet weak var streamInfoBtn: UIButton!
    @IBOutlet weak var online_numBackgroundView: UIView!
    @IBOutlet weak var online_numLabel: UILabel!
    @IBOutlet weak var dialogBoxTextField: UITextField!
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var chatRoomBackgroundView: UIView!
    @IBOutlet weak var chatRoomBackgroundViewConstraint: NSLayoutConstraint!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let YTPlayer = YTPlayerView()
    var playlist = ["I3440shDJYw", "xSbeUixi22o", "3OHT350Acj4", "_zvMspsjNgA", "tH4SMx_-5As"]
    var currentPlay: String = ""
    var isStream: Bool?
    var streamTitle: String?
    var online_num: Int?
    var streamerTags: String?
    var streamerName: String?
    var streamerAvatar: String?
    var animator = UIViewPropertyAnimator()
    var streamer_id: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        WebSocketManager.shared.establishConnection()
        addKeyboardObserver()
        setStreamInfoBtn()
        setonline_numLabel()
        setFollowBtn()
        if isStream == true {
            playerViewDidBecomeReady(YTPlayer) // 進入畫面 loading 完會自動播放
            playerView(YTPlayer, didChangeTo: .ended) // 播完會自動重播
            playStreamVedio()
        } else {
            playVedio()
        }
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
            self.chatRoomTableView.alpha = 0.4
            self.dialogBoxTextField.alpha = 0.4
        }, completion: { UIViewAnimatingPosition in
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRoomTableViewCell")
        setupLogoutButton()
        setupAlertView()
        setStreamInfoAndFollowBtnBackgroundView()
        setonline_numBackgroundView()
        setAlert()
        setshareBtn()
        setGiftBtn()
        YTPlayer.delegate = self
        WebSocketManager.shared.delegate = self
        dialogBoxTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        YTPlayer.playVideo()
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        YTPlayer.playVideo()
    }
    
    //串流影片
    func playStreamVedio() {
        YTPlayer.frame = self.view.bounds
        // 設定 control 0：無控制條，1：有控制條
        currentPlay = playlist.randomElement()!
        YTPlayer.load(withVideoId: currentPlay, playerVars: ["controls": 0])
        YTPlayer.webView?.configuration.allowsInlineMediaPlayback = true
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
    
    func setAlert() {
        alertExitBtn.setTitle(NSLocalizedString("alertExit", comment: ""), for: .normal)
        alertStayBtn.setTitle(NSLocalizedString("alertStay", comment: ""), for: .normal)
    }
    
    func setupLogoutButton() {
        logoutButton.layer.cornerRadius = 18
        logoutButton.backgroundColor = .black
        logoutButton.alpha = 0.7
    }
    
    func setupAlertView() {
        alertUIView.layer.cornerRadius = alertUIView.bounds.width / 8
    }
    
    func setFollowBtn() {
        followBtn.layer.cornerRadius = followBtn.bounds.height / 4
        FirebaseManager.shared.followList?.FollowList.forEach {
            if $0.streamerId == streamer_id {
                followBtn.isSelected = true
                followBtn.setTitle(NSLocalizedString("followBtnisSelected", comment: ""), for: .normal)
            } else {
                followBtn.isSelected = false
                followBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
            }
        }
    }
    
    func setStreamInfoAndFollowBtnBackgroundView() {
        streamInfoAndFollowBtnBackgroundView.layer.cornerRadius = streamInfoAndFollowBtnBackgroundView.bounds.height / 4
    }
    
    func setStreamInfoBtn() {
        streamInfoBtn.setTitle(streamTitle, for: .normal)
    }
    
    func setonline_numLabel() {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        online_numLabel.text = (formater.string(from: online_num! as NSNumber))
    }
    
    func setonline_numBackgroundView() {
        online_numBackgroundView.layer.cornerRadius = online_numBackgroundView.bounds.height / 4
    }
    
    func setshareBtn() {
        shareBtn.layer.cornerRadius = 18
        shareBtn.backgroundColor = .black
        shareBtn.alpha = 0.7
    }
    
    func setGiftBtn() {
        giftBtn.layer.cornerRadius = 18
    }
    
    @IBAction func clickFollowButton(_ sender: Any) {
        if FirebaseManager.shared.isSignIn == true {
        switch followBtn.isSelected {
        case true:
            followBtn.isSelected = false
            followBtn.setTitle(NSLocalizedString("followBtn", comment: ""), for: .normal)
            FirebaseManager.shared.deleteUserFollowList(streamer_id!, streamerName!)
        default :
            followBtn.isSelected = true
            followBtn.setTitle(NSLocalizedString("followBtnisSelected", comment: ""), for: .normal)
            FirebaseManager.shared.uploadUserFollowList(streamer_id!, streamerName!)
            WebSocketManager.shared.sendFollow()
        }
        } else {
            let alert = UIAlertController(title: NSLocalizedString("noSignIn", comment: ""), message: NSLocalizedString("noSignInDescription", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    @IBAction func clickLogoutButton(_ sender: Any) {
        alertUIView.isHidden = false
    }
    
    @IBAction func clickExitLiveStreamRoom(_ sender: Any) {
        YTPlayer.pauseVideo()
        player.pause()
        playerLayer.removeFromSuperlayer()
        YTPlayer.removeWebView()
        alertUIView.isHidden = true
        WebSocketManager.shared.disconnection()
        self.dismiss(animated: true)
    }
    @IBAction func clickStayLiveStreamRoom(_ sender: Any) {
        alertUIView.isHidden = true
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
    @IBAction func editdidEnd(_ sender: Any) {
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 2, options: .allowUserInteraction, animations: {
            self.chatRoomTableView.alpha = 0.4
            self.dialogBoxTextField.alpha = 0.4
        }, completion: { UIViewAnimatingPosition in
        })
    }
    @IBAction func touchdown(_ sender: Any) {
        animator.stopAnimation(true)
        self.chatRoomTableView.alpha = 0.7
        self.dialogBoxTextField.alpha = 0.7
    }
    
    @IBAction func clickShareBtn(_ sender: Any) {
        //原生 分享
        var shareURL = URL(string: "")
        if isStream == true {
            print(currentPlay)
            shareURL = URL(string: "https://www.youtube.com/watch?v=\(currentPlay)")
        } else {
            shareURL = URL(string: "https://weakself.dev/episodes/46")!
        }
        let items: [Any] = ["#泡泡直播",shareURL]

        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)

        // Line 分享
//        let application = UIApplication.shared
//        let url = URL(string: "https://line.me/R/msg/text/?https://www.youtube.com/watch?v=\(currentPlay)")
//        if application.canOpenURL(url!) {
//            application.open(url!,options: [:],completionHandler: nil)
//        } else {
//            let lineURL = URL(string: "https://line.me/R/")
//            application.open(lineURL!, options: [:], completionHandler: nil)
//        }
    }
    @IBAction func clickStreamerInfoBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StreamerInfomation") as! StreamerInfomationVC
        vc.modalPresentationStyle = .overFullScreen
        vc.streamerAvatar = streamerAvatar
        vc.streamerName = streamerName
        vc.streamerTags = streamerTags
        vc.streamer_id = streamer_id
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func clickGiftBtn(_ sender: Any) {
        if FirebaseManager.shared.isSignIn == true {
            let vc = storyboard?.instantiateViewController(withIdentifier: "GiftVC") as! GiftVC
            vc.modalPresentationStyle = .overFullScreen
            vc.streamerName = streamerName
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("noSignIn", comment: ""), message: NSLocalizedString("noSignInDescription", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension LiveStreamRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebSocketManager.shared.webSocketReceive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
        cell.selectionStyle = .none
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        let index = WebSocketManager.shared.webSocketReceive.count - 1 - indexPath.row
       
        if WebSocketManager.shared.webSocketReceive[index].event.contains("sys_updateRoomStatus") {
            if WebSocketManager.shared.webSocketReceive[index].body.entry_notice?.action == "enter" {
                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(WebSocketManager.shared.webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemEnter", comment: ""))"
            } else {
                cell.chatTextView.text = "\(NSLocalizedString("system", comment: ""))\(WebSocketManager.shared.webSocketReceive[index].body.entry_notice!.username!)\(NSLocalizedString("systemLeave", comment: ""))"
            }
        } else if WebSocketManager.shared.webSocketReceive[index].event.contains("default_message") {
            cell.chatTextView.text = "\(WebSocketManager.shared.webSocketReceive[index].body.nickname!)： \(WebSocketManager.shared.webSocketReceive[index].body.text!)"
        } else if WebSocketManager.shared.webSocketReceive[index].event.contains("admin_all_broadcast") {
            if UserDefaults.standard.stringArray(forKey: "AppleLanguages")![0].contains("zh-Hans") {
                cell.chatTextView.text = WebSocketManager.shared.webSocketReceive[index].body.content?.cn
            } else if UserDefaults.standard.stringArray(forKey: "AppleLanguages")![0].contains("zh-Hant") {
                cell.chatTextView.text = WebSocketManager.shared.webSocketReceive[index].body.content?.tw
            } else {
                cell.chatTextView.text = WebSocketManager.shared.webSocketReceive[index].body.content?.en
            }
        }
        return cell
    }
}

// MARK: - WebSocket Delegate
extension LiveStreamRoomViewController: WebSocketManagerDelegate {
    
    func receiveFinishReload() {
        chatRoomTableView.reloadData()
        if WebSocketManager.shared.webSocketReceive.count > 0 {
            self.chatRoomTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        }
    }
    
}

// MARK: - Keyboard Event Handling
extension LiveStreamRoomViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.chatRoomBackgroundViewConstraint.constant = keyboardHeight - 30
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        chatRoomBackgroundViewConstraint.constant = 29
    }
}

//MARK: - UITextFieldDelegate
extension LiveStreamRoomViewController: UITextFieldDelegate {
    
    // 按下return的事件處理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if dialogBoxTextField.text!.trimmingCharacters(in: .whitespaces) == "" {
            // 未輸入內容或輸入為空字串，會跳Alert提醒
            self.showAlertInfo("請輸入內容", y: self.chatRoomBackgroundView.frame.origin.y)
            dialogBoxTextField.text?.removeAll() //送出後要重置輸入框
            dialogBoxTextField.resignFirstResponder()
            print("Input is empty")
        } else {
            if dialogBoxTextField.returnKeyType == .send {
                WebSocketManager.shared.send(dialogBoxTextField.text!)
                dialogBoxTextField.text?.removeAll() //送出後要重置輸入框
                dialogBoxTextField.resignFirstResponder()
                return true
            }
        }
        return false
    }
}

extension LiveStreamRoomViewController: StreamerInfomationDelegate {
    
    func followBtnUpdate(text: String) {
        followBtn.setTitle(text, for: .normal)
        if followBtn.isSelected == true {
            followBtn.isSelected = false
        } else {
            followBtn.isSelected = true
        }
    }
    
}

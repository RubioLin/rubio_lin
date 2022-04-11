//
//  LiveStramRoomViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/10.
//

import UIKit

class LiveStreamRoomViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    static let LiveStreamRoom = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamRoom")
    
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
    
    func setLogOutButton() {
        logoutButton.layer.cornerRadius = 22
        logoutButton.backgroundColor = UIColor.systemGray
    }
    
    func setAlert() {
        let alert = UIAlertController(title: "", message: "確定離開此聊天室？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "立馬走", style: .default, handler: { UIAlertAction in
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "先不要", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    @IBAction func clickLogoutButton(_ sender: Any) {
        setAlert()
    }
}

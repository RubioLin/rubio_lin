import UIKit
import Foundation
import SwiftUI

let userDefaults = UserDefaults.standard

class HomePageViewController: UIViewController, UITabBarDelegate, UITabBarControllerDelegate {
    
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage")
    @IBOutlet weak var LiveRoomCollectionView: UICollectionView!
    var result: JsonResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseManager.shared.getUserInfo()
        FirebaseManager.shared.getUserFollowList()
        self.LiveRoomCollectionView.reloadData()
    }
    
    // 要register Colletion View 的 Cell 和 Header
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.LiveRoomCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        self.LiveRoomCollectionView.register(UINib(nibName: "HomePageHeaderReusableView", bundle: nil), forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomePageHeaderReusableView")
        result = FetchJsonModal.shared.load("Result.json") // 解析本地 json 資料
        FirebaseManager.shared.delegate = self
        tabBarController?.delegate = self
        tabBarController?.tabBar.tintColor = .black
    }
}

// MARK: - 設定Colletion View DataSource
extension HomePageViewController: UICollectionViewDataSource {
    
    // 設置 Collection View 的 Header在有登入時存在，未登入則高度為零
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if FirebaseManager.shared.isSignIn == true {
            return CGSize(width: self.view.bounds.width, height: 40)
        } else {
            return CGSize(width: 0.0, height: 0.0)
        }
    }
    
    // 設置 Collection View 的 Header，判斷有無使用者決定 Header 的內容
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = LiveRoomCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomePageHeaderReusableView", for: indexPath) as? HomePageHeaderReusableView
            if FirebaseManager.shared.isSignIn == true {
                if let url = FirebaseManager.shared.userInfo?.userPhotoUrl {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        DispatchQueue.main.async {
                            header?.currentUserHeadPhotoImageView.image = UIImage(data: data ?? Data())
                            header?.currentUserNicknameLabel.text = FirebaseManager.shared.userInfo?.nickname
                        }
                    }.resume()
            }
        }
        return header!
    }
    
    // 設置 Collection View 的 Cell 數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.stream_list.count ?? 0
    }
    
    // 設置 Collection View 的 Cell 內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        
        // 設置cell的主播名稱和直播間名稱
        cell?.stream_titleLabel.text = String((result?.stream_list[indexPath.row]?.nickname)!) + "   " + String((result?.stream_list[indexPath.row]?.stream_title)!)
        // 設置cell的tags，並加以判斷，無內容不顯示
        if result?.stream_list[indexPath.row]?.tags == "" {
            cell?.tagsLabel.isHidden = true
        } else {
            cell?.tagsLabel.text = "#" + String(result?.stream_list[indexPath.row]?.tags ?? "")
        }
        // 設置cell的人數
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        if let onlinerNum = result?.stream_list[indexPath.row]?.online_num {
            cell?.online_numLabel.text = (formater.string(from: onlinerNum as NSNumber) ?? "") + "  "
        }
        // 設置cell的主播圖片
        if let url = URL(string: result?.stream_list[indexPath.row]?.head_photo ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as?
                        //判斷 Server 回傳的 Response 的 statusCode 可知是否有圖片，沒有圖片就用預設的圖
                        HTTPURLResponse,(200...201).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        cell?.head_photoImageView.image = UIImage(named: "paopao.png")
                    }
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell?.head_photoImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell!
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    //設定Collection View 和 Super View 的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    //設定Collection View 的寬高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width - 30) / 2 , height: (self.view.frame.size.width - 30) / 2)
    }
    
    //設定Collection View 的 Cell 彼此的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - 設定Collection View Delegate
extension HomePageViewController: UICollectionViewDelegate {
    // 點選 Cell 進入直播間，點 index 偶數間進入 Youtube 串流影片，基數間進入本地影片
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let transitionView = UIHostingController(rootView: FireworkView())
        transitionView.modalPresentationStyle = .overFullScreen
        transitionView.view.backgroundColor = .clear
        present(transitionView, animated: false) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { Timer in
                self.dismiss(animated: false)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { Timer in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamRoom") as! LiveStreamRoomViewController
            vc.modalPresentationStyle = .fullScreen
            if indexPath.row % 2 == 0 {
                vc.isStream = true
            } else {
                vc.isStream = false
            }
            vc.streamTitle = self.result?.stream_list[indexPath.row]?.stream_title
            vc.streamerTags = self.result?.stream_list[indexPath.row]?.tags
            vc.streamerName = self.result?.stream_list[indexPath.row]?.nickname
            vc.streamerAvatar = self.result?.stream_list[indexPath.row]?.head_photo
            vc.online_num = self.result?.stream_list[indexPath.row]?.online_num
            vc.streamer_id = self.result?.stream_list[indexPath.row]?.streamer_id
            self.present(vc, animated: true)
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    
    }

    
}

extension HomePageViewController: FirebaseManagerDelegate {
    
    func getUserInfoFinishReload() {
        self.LiveRoomCollectionView.reloadData()
    }
    
}

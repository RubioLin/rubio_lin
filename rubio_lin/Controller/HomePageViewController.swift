//
//  ViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/29.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomePageViewController: UIViewController {
    
    static let HomePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage")
    @IBOutlet weak var LiveRoomCollectionView: UICollectionView!
    static var isSignIn: Bool?
    var result: JsonResult?
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LiveRoomCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.LiveRoomCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        self.LiveRoomCollectionView.register(UINib(nibName: "HomePageHeaderReusableView", bundle: nil), forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomePageHeaderReusableView")
        result = Network.shared.load("Result.json")
    }
}




// MARK: - 設定Colletion View

extension HomePageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = LiveRoomCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomePageHeaderReusableView", for: indexPath) as? HomePageHeaderReusableView
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            header?.isHidden = false
            if let currentUser = Auth.auth().currentUser {
                if let email = currentUser.email {
                    self.db.collection("userInfo").document(email).getDocument { document, error in
                        guard let documents = document, documents.exists, let user = try? documents.data(as: UserInfo.self) else { return }
                        URLSession.shared.dataTask(with: user.userPhotoUrl) { data, response, error in
                            DispatchQueue.main.async {
                                header?.currentUserNicknameLabel.text = user.nickname
                                header?.currentUserHeadPhotoImageView.image = UIImage(data: data!)
                            }
                        }.resume()
                    }
                }
            } else {
                header?.isHidden = true
            }
        }
        return header!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.stream_list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        cell?.stream_titleLabel.text = result?.stream_list[indexPath.row]?.nickname
        if result?.stream_list[indexPath.row]?.tags == "" {
            cell?.tagsLabel.isHidden = true
        } else {
            cell?.tagsLabel.text = "#" + String(result?.stream_list[indexPath.row]?.tags ?? "")
        }
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        if let a = result?.stream_list[indexPath.row]?.online_num {
            cell?.online_numLabel.text = (formater.string(from: a as NSNumber) ?? "") + "  "
        }
        
        if let url = URL(string: result?.stream_list[indexPath.row]?.head_photo ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as?
                    // MARK: -
                    // 查詢為什麼要有，
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension HomePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LiveStreamRoomViewController.LiveStreamRoom.modalPresentationStyle = .fullScreen
        self.present(LiveStreamRoomViewController.LiveStreamRoom, animated: true)
    }
    
}

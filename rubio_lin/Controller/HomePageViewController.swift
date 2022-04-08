//
//  ViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/29.
//

import UIKit
import Foundation
import FirebaseAuth

class HomePageViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var LiveRoomCollectionView: UICollectionView!
    static var isSignIn: Bool?
    var result: Resultt?
    let lightyear_list: [LightyearList] = []
    let stream_list: [StreamList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.LiveRoomCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        result = Network.shard.load("Result.json")
    }
}





extension HomePageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.stream_list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        cell?.stream_titleLabel.text = result?.stream_list[indexPath.row]?.stream_title
        cell?.tagsLabel.text = "#" + String(result?.stream_list[indexPath.row]?.tags ?? "")
        
        if let url = URL(string: result?.stream_list[indexPath.row]?.head_photo ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,(200...201).contains(httpResponse.statusCode) else {
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

// MARK: - 設定Colletion View
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    //設定Collection View 和 Super View 的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    //設定Collection View 的寬高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width - 30) / 2 , height: (self.view.frame.size.width - 30) / 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


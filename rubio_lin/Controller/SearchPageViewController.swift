//
//  SearchViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit

class SearchPageViewController: UIViewController {
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var l: UILabel!
    var result: JsonResult?
    var lightyear_list: [LightyearList] = []
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        result = Network.shard.load("Result.json")
        self.searchBar.delegate = self
        searchBar.setImage(UIImage(named: "titlebarSearch"), for: .search, state: .normal)
    }
}
// MARK: - 設定Collection View DataSource
extension SearchPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch == true {
            return lightyear_list.count
            
        } else {
            return result?.lightyear_list.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        
        if isSearch == true {
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            if let a = lightyear_list[indexPath.row].online_num {
                cell?.online_numLabel.text = (formater.string(from: a as! NSNumber) ?? "") + "  "
            }
            cell?.stream_titleLabel.text = lightyear_list[indexPath.row].nickname
            cell?.tagsLabel.text = "#" + String(lightyear_list[indexPath.row].tags ?? "")
            if let url = URL(string: lightyear_list[indexPath.row].head_photo ?? "") {
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
        } else {
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            if let a = result?.lightyear_list[indexPath.row]?.online_num {
                cell?.online_numLabel.text = (formater.string(from: a as! NSNumber) ?? "") + "  "
            }
            cell?.stream_titleLabel.text = result?.lightyear_list[indexPath.row]?.nickname
            cell?.tagsLabel.text = "#" + String(result?.lightyear_list[indexPath.row]?.tags ?? "")
            if let url = URL(string: result?.lightyear_list[indexPath.row]?.head_photo ?? "") {
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
        }
        
        
        return cell!
    }
}


// MARK: - 設定Colletion View FlowLayout
extension SearchPageViewController: UICollectionViewDelegateFlowLayout {

    //設定Collection View 和 Super View 的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
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

// MARK: - 設定Collection View Delegate
extension SearchPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LiveStreamRoomViewController.LiveStreamRoom.modalPresentationStyle = .fullScreen
        self.present(LiveStreamRoomViewController.LiveStreamRoom, animated: true)
    }
}

// MARK: - 設定SearchBar
extension SearchPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearch = false
            l.text = "熱門直播"
        } else {
            isSearch = true
            lightyear_list = result?.lightyear_list.filter { ($0?.tags!.contains(searchText))! || ($0?.nickname!.contains(searchText))! || ($0?.stream_title!.contains(searchText))! } as! [LightyearList]
            l.text = "搜尋結果"
        }
        recommendCollectionView.reloadData()
    }
}


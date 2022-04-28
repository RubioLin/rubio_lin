import UIKit

class SearchPageViewController: UIViewController {
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var result: JsonResult?
    var searching_list: [StreamList] = []
    var isSearch: Bool = false // 判斷是否為搜尋中
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    // 要register Colletion View 的 Cell 和 Header
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        self.recommendCollectionView.register(UINib(nibName: "SearchPageHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchPageHeaderReusableView")
        result = FetchJsonModal.shared.load("Result.json") // 解析本地 json 資料
        // 將 SearchBar 的 Delegate 設為此 Controller，並設置其圖片
        self.searchBar.delegate = self
        searchBar.setImage(UIImage(named: "titlebarSearch"), for: .search, state: .normal)
    }
    // 按下 search 鍵盤會收起來
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
// MARK: - 設定Collection View DataSource
extension SearchPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSearch == true {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = recommendCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchPageHeaderReusableView", for: indexPath) as? SearchPageHeaderReusableView
        if isSearch == true {
            if indexPath.section == 0 {
                header?.recommendAndSearchLabel.text = NSLocalizedString("search", comment: "")
            } else {
                header?.recommendAndSearchLabel.text = NSLocalizedString("recommend", comment: "")
            }
        } else {
            header?.recommendAndSearchLabel.text = NSLocalizedString("recommend", comment: "")
        }
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch == true {
            if section == 0 {
                return searching_list.count
            } else {
                return result?.lightyear_list.count ?? 0
            }
        } else {
            return result?.lightyear_list.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        
        if isSearch == true {
            if indexPath.section == 0 {
                let formater = NumberFormatter()
                formater.numberStyle = .decimal
                if let a = searching_list[indexPath.row].online_num {
                    cell?.online_numLabel.text = (formater.string(from: a as NSNumber) ?? "")
                }
                cell?.stream_titleLabel.text = searching_list[indexPath.row].nickname! + "   " + searching_list[indexPath.row].stream_title!
                if searching_list[indexPath.row].tags == "" {
                    cell?.tagsLabel.isHidden = true
                } else {
                    cell?.tagsLabel.text = "#" + String(searching_list[indexPath.row].tags ?? "")
                }
                if let url = URL(string: searching_list[indexPath.row].head_photo ?? "") {
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
                    cell?.online_numLabel.text = (formater.string(from: a as NSNumber) ?? "")
                }
                cell?.stream_titleLabel.text = (result?.lightyear_list[indexPath.row]?.nickname!)! + "   " + (result?.lightyear_list[indexPath.row]?.stream_title!)!
                if result?.lightyear_list[indexPath.row]?.tags == "" {
                    cell?.tagsLabel.isHidden = true
                } else {
                    cell?.tagsLabel.text = "#" + String(result?.lightyear_list[indexPath.row]?.tags ?? "")
                }
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
        } else {
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            if let a = result?.lightyear_list[indexPath.row]?.online_num {
                cell?.online_numLabel.text = (formater.string(from: a as NSNumber) ?? "")
            }
            cell?.stream_titleLabel.text = (result?.lightyear_list[indexPath.row]?.nickname)! + "   " + (result?.lightyear_list[indexPath.row]?.stream_title!)!
            if result?.lightyear_list[indexPath.row]?.tags == "" {
                cell?.tagsLabel.isHidden = true
            } else {
                cell?.tagsLabel.text = "#" + String(result?.lightyear_list[indexPath.row]?.tags ?? "")
            }
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
    
    //設定Collection View 的 Cell 彼此的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

// MARK: - 設定Collection View Delegate
extension SearchPageViewController: UICollectionViewDelegate {
    
    // 點選Cell進入直播間
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            LiveStreamRoomViewController.shared.isStream = true
        } else {
            LiveStreamRoomViewController.shared.isStream = false
        }
        LiveStreamRoomViewController.shared.modalPresentationStyle = .fullScreen
        self.present(LiveStreamRoomViewController.shared, animated: true)
    }
}

// MARK: - 設定SearchBar
extension SearchPageViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearch = false
        } else {
            isSearch = true
            // 不管大小寫都會進行 filter 裝進新陣列 $0指得是result?.stream_list的各項
            searching_list = result?.stream_list.filter { ($0?.tags!.localizedCaseInsensitiveContains(searchText))! || ($0?.nickname!.localizedCaseInsensitiveContains(searchText))! || ($0?.stream_title!.localizedCaseInsensitiveContains(searchText))! } as! [StreamList]
        }
        recommendCollectionView.reloadData()
    }
}

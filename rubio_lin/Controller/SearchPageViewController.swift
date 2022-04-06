//
//  SearchViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/3/31.
//

import UIKit

class SearchPageViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    var result: Result?
    let lightyear_list: [LightyearList] = []
    let stream_list: [StreamList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LiveRoomCollectionViewCell", bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: "LiveRoomCollectionViewCell")
        result = Network.shard.load("Result.json")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - 設定Collection View DataSource
extension SearchPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.lightyear_list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCollectionViewCell", for: indexPath) as? LiveRoomCollectionViewCell
        cell?.stream_titleLabel.text = result?.lightyear_list[indexPath.row]?.stream_title
        cell?.tagsLabel.text = "#" + String(result?.lightyear_list[indexPath.row]?.tags ?? "")
        
        if let url = URL(string: result?.lightyear_list[indexPath.row]?.head_photo ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
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


// MARK: - 設定Colletion View FlowLayout
extension SearchPageViewController: UICollectionViewDelegateFlowLayout {

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

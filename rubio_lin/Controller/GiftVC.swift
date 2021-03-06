import UIKit
import SwiftUI

class GiftVC: UIViewController {
    
    @IBOutlet weak var giftCV: UICollectionView!
    
    var giftNameArray = ["幽浮", "跑車", "遊艇", "火箭", "鑽石", "水晶", "泡泡"]
    var giftPriceArray = [5000, 500, 1000, 2500, 250, 100, 10]
    var giftPicArray = ["ufo-gradient", "sportcar-gradient", "yacht-gradient", "rocket-gradient", "diamond-gradient",  "crystal-gradient", "bubbles-gradient"]
    var streamerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giftCV.register(UINib(nibName: "GiftCVCell", bundle: nil), forCellWithReuseIdentifier: "GiftCVCell")
        giftCV.delegate = self
        giftCV.dataSource = self
        giftCV.reloadData()
    }
    
    @IBAction func touchDown(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension GiftVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCVCell", for: indexPath) as! GiftCVCell
        cell.giftNameL.text = giftNameArray[indexPath.row]
        cell.giftPriceL.text = "\(giftPriceArray[indexPath.row])"
        cell.giftPicIV.image = UIImage(named: giftPicArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    //設定Collection View 的 Cell 彼此的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "確定要送給\(streamerName!)\(giftNameArray[indexPath.row])", message: "\(streamerName!)會很開心的", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { UIAlertAction in
            let vc = UIHostingController(rootView: GiftView(imageName: self.giftPicArray[indexPath.row]))
            vc.modalPresentationStyle = .overFullScreen
            vc.view.backgroundColor = .clear
            self.present(vc, animated: false) {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { Timer in
                    self.dismiss(animated: false)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "先不要", style: .cancel))
        present(alert, animated: true)
    }

}


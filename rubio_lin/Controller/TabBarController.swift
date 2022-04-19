//
//  TabBarViewController.swift
//  rubio_lin
//
//  Created by Class on 2022/4/18.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var firstTabbarItemImageView: UIImageView!
    var secondTabbarItemImageView: UIImageView!
    var thirdTabbarItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstItemView = tabBar.subviews.first!
        self.firstTabbarItemImageView = firstItemView.subviews.first as? UIImageView
        print(firstItemView.subviews)
        self.firstTabbarItemImageView.contentMode = .center
        self.firstTabbarItemImageView.clipsToBounds = true
        let secondItemView = self.tabBar.subviews[1]
        self.secondTabbarItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondTabbarItemImageView.contentMode = .center
        self.secondTabbarItemImageView.clipsToBounds = true
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdTabbarItemImageView.contentMode = .center
        self.thirdTabbarItemImageView.clipsToBounds = true
        self.delegate = self

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            self.firstTabbarItemImageView.transform = CGAffineTransform(scaleX: 3, y: 3)
            UIView.animate(withDuration: 0.5) {
                self.firstTabbarItemImageView.transform = .identity
            }
        } else if item.tag == 1 {
            self.secondTabbarItemImageView.transform = CGAffineTransform(scaleX: 3, y: 3)
            UIView.animate(withDuration: 0.5) {
                self.secondTabbarItemImageView.transform = .identity
            }
        } else {
            self.thirdTabbarItemImageView.transform = CGAffineTransform(scaleX: 3, y: 3)
            UIView.animate(withDuration: 0.5) {
                self.thirdTabbarItemImageView.transform = .identity
            }
        }
    }
    
}

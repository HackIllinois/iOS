//
//  HITabBarController.swift
//  HackIllinois
//
//  Created by Alex Drewno on 11/13/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HITabBarController: UITabBarController {
    var hiTabBar: HITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        createTabBarButtons()
    }

    private func setTabBar(items: [UITabBarItem], height: CGFloat = 64) {
        hiTabBar = HITabBar(frame: tabBar.frame)
        hiTabBar.items = items
        hiTabBar.unselectedItemTintColor = UIColor.white
        hiTabBar.tintColor = UIColor(red: 0.89, green: 0.31, blue: 0.35, alpha: 1.0)
        guard hiTabBar != nil else { return }

        self.view.addSubview(hiTabBar)
    }

    func getItems() -> [String] {
        var items: [String] = []
        for vc in viewControllers ?? [] {
            items.append(vc.title ?? "")
        }
        return items
    }

    func createTabBarButtons() {
        let homeTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: nil)
        let scheduleTabBarItem = UITabBarItem(title: "", image: UIImage(named: "White_Schedule"), selectedImage: nil)
        let QRCodeTabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        let mapsTabBarItem = UITabBarItem(title: "", image: UIImage(named: "White_Maps"), selectedImage: nil)
        let profileTabBarItem = UITabBarItem(title: "", image: UIImage(named: "White_Profile"), selectedImage: nil)
        setTabBar(items: [homeTabBarItem, scheduleTabBarItem, QRCodeTabBarItem, mapsTabBarItem, profileTabBarItem])
    }

}

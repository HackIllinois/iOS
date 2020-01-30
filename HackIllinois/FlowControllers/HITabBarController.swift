//
//  HITabBarController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/21/18.
//  Copyright © 2020 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITabBarController: UITabBarController {

    // Animation for when a tab bar item is clicked
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 54, height: 54)
        button.layer.cornerRadius = 28
        button.center = CGPoint(x: view.center.x, y: 0)
        button.backgroundColor = UIColor(red: 0.89, green: 0.31, blue: 0.35, alpha: 1.0)
        button.setImage(#imageLiteral(resourceName: "qr-code"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = UIColor.white
        button.addTarget(self, action: #selector(qrButtonPressed(_:)), for: .touchUpInside)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        button.constrain(width: 54, height: 54)
    }

    @objc private func qrButtonPressed(_ sender: UIButton) {
        print("Button Clicked")
    }

    // Animates clicking a tab bar item
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // find index if the selected tab bar item, then find the corresponding view and get its image, the view position is offset by 2 because the first item is the background and second item is the QR Code
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.first as? UIImageView else {
            return
        }

        imageView.layer.add(bounceAnimation, forKey: nil)
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        //Set the tabbar to be a HITabBar
        object_setClass(self.tabBar, HITabBar.self)
        (self.tabBar as? HITabBar)?.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupMenuFor(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers.map {
            _ = $0.view // forces viewDidLoad to run, allows .title to be accessible
            return HINavigationController(rootViewController: $0)
        }
    }
}

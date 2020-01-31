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
    lazy var qrPopup = HIPopupViewController()
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

        //Setup QRCode Button
        let qrButton = UIButton()
        view.addSubview(qrButton)
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.frame.size = CGSize(width: 54, height: 54)
        qrButton.layer.cornerRadius = 28
        qrButton.center = CGPoint(x: view.center.x, y: 0)
        qrButton.backgroundColor = UIColor(red: 0.89, green: 0.31, blue: 0.35, alpha: 1.0)
        qrButton.setImage(#imageLiteral(resourceName: "qr-code"), for: .normal)
        qrButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        qrButton.imageView?.contentMode = .scaleAspectFill
        qrButton.imageView?.tintColor = UIColor.white

        // Button Shadow
        qrButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        qrButton.layer.shadowOpacity = 1
        qrButton.layer.shadowRadius = 15
        qrButton.layer.masksToBounds = false
        qrButton.layer.shadowOffset = CGSize(width: 0, height: 0)

        //QR Code Button Constraints
        qrButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        qrButton.constrain(width: 54, height: 54)

        //QR Code Popup Action
        qrButton.addTarget(self, action: #selector(qrButtonPressed(_:)), for: .touchUpInside)
    }

    @objc private func qrButtonPressed(_ sender: UIButton) {
        qrPopup.modalPresentationStyle = .overCurrentContext
        qrPopup.transitioningDelegate = qrPopup
        self.present(qrPopup, animated: true, completion: nil)
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        //Set the tabbar to be a HITabBar
        object_setClass(self.tabBar, HITabBar.self)
        (self.tabBar as? HITabBar)?.setup()

        moreNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "DisclosureIndicator"), tag: 0)
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

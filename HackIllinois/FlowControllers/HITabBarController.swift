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
    private var tabBarShapeLayer: CAShapeLayer?

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
        setupCodePopupButton()
        setupTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //Redefine the tab bar path when orientation rotated
        if let tabBarShapeLayer = tabBarShapeLayer {
            tabBarShapeLayer.path = createPath()
        }
    }

    @objc private func codePopupButtonPressed(_ sender: UIButton) {
        let scanQRCodePopup = HICodePopupViewController()
        scanQRCodePopup.modalPresentationStyle = .overCurrentContext
        scanQRCodePopup.modalTransitionStyle = .crossDissolve
        self.present(scanQRCodePopup, animated: true, completion: nil)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        moreNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "DisclosureIndicator"), tag: 0)
    }

    func setupCodePopupButton() {
        //Setup Code Popup Button
        let codePopupButton = UIButton()
        view.addSubview(codePopupButton)
        codePopupButton.translatesAutoresizingMaskIntoConstraints = false
        codePopupButton.frame.size = CGSize(width: 54, height: 54)
        codePopupButton.layer.cornerRadius = 28
        codePopupButton.center = CGPoint(x: view.center.x, y: 0)
        codePopupButton.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.4470588235, alpha: 1)
        codePopupButton.setImage(#imageLiteral(resourceName: "CodePopupTabIcon"), for: .normal)
        codePopupButton.imageView?.contentMode = .scaleAspectFill
        codePopupButton.imageView?.tintColor = UIColor.white

        // Button Shadow
        codePopupButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        codePopupButton.layer.shadowOpacity = 1
        codePopupButton.layer.shadowRadius = 15
        codePopupButton.layer.masksToBounds = false
        codePopupButton.layer.shadowOffset = CGSize(width: 0, height: 0)

        //Code Popup Button Constraints
        codePopupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codePopupButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        codePopupButton.constrain(width: 54, height: 54)

        //Code Popup Action
        codePopupButton.addTarget(self, action: #selector(codePopupButtonPressed(_:)), for: .touchUpInside)
    }

    func setupTabBar() {
        let tabBarFrame = self.tabBar.frame
        tabBar.frame = CGRect(x: tabBarFrame.minX, y: tabBarFrame.minY, width: tabBarFrame.width, height: UIScreen.main.bounds.height - tabBarFrame.height + 28)
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
        tabBar.layer.borderWidth = 0
        tabBar.backgroundColor = UIColor.clear
        tabBar.unselectedItemTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        tabBar.tintColor = UIColor.white

        addTabBarShape()
    }

    func addTabBarShape() {
        tabBarShapeLayer = CAShapeLayer()
        if let tabBarShapeLayer = tabBarShapeLayer {
            tabBarShapeLayer.path = createPath()
            tabBarShapeLayer.fillColor = UIColor(red: 0.435, green: 0.549, blue: 0.757, alpha: 1.0).cgColor
            tabBarShapeLayer.lineWidth = 1.0

            self.tabBar.layer.insertSublayer(tabBarShapeLayer, at: 0)
        }
    }

    func createPath() -> CGPath {
        let radius: CGFloat = 32.0
        let smallRadius: CGFloat = 8.0
        let path = UIBezierPath()

        // start top left before rounded corner
        path.move(to: CGPoint(x: 0, y: 0 + smallRadius))

        // top left rounded corner
        path.addArc(withCenter: CGPoint(x: smallRadius, y: smallRadius),
                    radius: smallRadius,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: true)

        // start of left arc before middle arc
        path.addLine(to: CGPoint(x: (self.tabBar.frame.width/2 - radius - smallRadius/2), y: 0))

        // end of left arc before middle arc
        path.addArc(withCenter: CGPoint(x: self.tabBar.frame.width/2 - radius - smallRadius/2, y: smallRadius/2),
                    radius: smallRadius/2,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: true)

        // middle arc
        path.addArc(withCenter: CGPoint(x: self.tabBar.frame.width/2, y: 0),
                    radius: radius,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)

        // right arc after middle arc
        path.addArc(withCenter: CGPoint(x: self.tabBar.frame.width/2 + radius + smallRadius/2, y: smallRadius/2),
                    radius: smallRadius/2,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: true)

        // before top right rounded corner
        path.addLine(to: CGPoint(x: self.tabBar.frame.width - smallRadius, y: 0))

        // top right rounded corner
        path.addArc(withCenter: CGPoint(x: self.tabBar.frame.width - smallRadius, y: smallRadius),
                    radius: smallRadius,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: true)

        // finish the rest
        path.addLine(to: CGPoint(x: self.tabBar.frame.width, y: UIScreen.main.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        path.close()

        return path.cgPath
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

//
//  HITabBar.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/26/20.
//  Copyright © 2020 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITabBar: UITabBar {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: UIScreen.main.bounds.height - frame.height+28)
        backgroundImage = UIImage()
        shadowImage = UIImage()
        clipsToBounds = true
        layer.borderWidth = 0
        backgroundColor = UIColor.clear
        unselectedItemTintColor = UIColor.white
        tintColor = UIColor(red: 0.89, green: 0.314, blue: 0.345, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
        draw(frame)
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor(red: 0.13, green: 0.17, blue: 0.36, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0

        self.layer.insertSublayer(shapeLayer, at: 0)

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
        path.addLine(to: CGPoint(x: (self.frame.width/2 - radius - smallRadius/2), y: 0))

        // end of left arc before middle arc
        path.addArc(withCenter: CGPoint(x: self.frame.width/2 - radius - smallRadius/2, y: smallRadius/2),
                    radius: smallRadius/2,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: true)

        // middle arc
        path.addArc(withCenter: CGPoint(x: self.frame.width/2, y: 0),
                    radius: radius,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)

        // right arc after middle arc
        path.addArc(withCenter: CGPoint(x: self.frame.width/2 + radius + smallRadius/2, y: smallRadius/2),
                    radius: smallRadius/2,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: true)

        // before top right rounded corner
        path.addLine(to: CGPoint(x: self.frame.width - smallRadius, y: 0))

        // top right rounded corner
        path.addArc(withCenter: CGPoint(x: self.frame.width - smallRadius, y: smallRadius),
                    radius: smallRadius,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: true)

        // finish the rest
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {

    }

}

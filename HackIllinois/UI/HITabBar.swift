//
//  HITabBar.swift
//  HackIllinois
//
//  Created by Alex Drewno on 11/13/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HITabBar: UITabBar {

    private var shapeLayer: CALayer?
    private var backgroundHIColor: HIColor = \.action
    var qrButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor(red: 0.13, green: 0.17, blue: 0.36, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    func setupView() {
        qrButton = UIButton()
        self.addSubview(qrButton)
        qrButton.frame.size = CGSize(width: 54, height: 54)
        qrButton.setImage(UIImage(named: "White_QRCode"), for: .normal)
        qrButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        qrButton.layer.cornerRadius = 28
        qrButton.imageView?.contentMode = .scaleAspectFill
        qrButton.center = CGPoint(x: self.center.x, y: 0)
        qrButton.backgroundColor = UIColor(red: 0.89, green: 0.31, blue: 0.35, alpha: 1.0)
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

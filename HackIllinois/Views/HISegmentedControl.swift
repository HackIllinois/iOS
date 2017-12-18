//
//  HISegmentedControl.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/29/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class HISegmentedControl: UIControl {

    var items: [String] = ["Friday", "Saturday", "Sunday"] {
        didSet { setupLabels() }
    }

    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
            sendActions(for: .valueChanged)
        }
    }


    private var labels = [UILabel]()
    var font                 = UIFont.systemFont(ofSize: 13, weight: .medium)
    var selectedLabelColor   = UIColor(named: "darkIndigo")
    var unselectedLabelColor = UIColor(named: "darkIndigo")


    var indicatorView = UIView()
    var indicatorViewColor   = UIColor(named: "hotPink")
    var indicatorViewHeight  = CGFloat(3)


    var bottomView = UIView()
    var bottomViewColor = UIColor(named: "hotPink")
    var bottomViewHeight = CGFloat(1)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }


    func setupView(){
        setupLabels()
        insertSubview(indicatorView, at: 0)
        insertSubview(bottomView, at: 0)
    }

    func setupLabels(){
        labels.forEach { $0.removeFromSuperview() }

        labels.removeAll(keepingCapacity: true)

        for (index, item) in items.enumerated() {
            let label = UILabel()
            label.text = items[index]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = index == 0 ? selectedLabelColor : unselectedLabelColor
            label.text = item
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labels.append(label)
        }

        constrain(labels: labels)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let indicatorViewWidth = frame.width / CGFloat(items.count)
        indicatorView.frame = CGRect(x: 0, y: frame.height - indicatorViewHeight, width: indicatorViewWidth, height: indicatorViewHeight)
        indicatorView.backgroundColor = indicatorViewColor

        bottomView.frame = CGRect(x: 0, y: frame.height - (2 * bottomViewHeight), width: frame.width, height: bottomViewHeight)
        bottomView.backgroundColor = bottomViewColor

        displayNewSelectedIndex()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        for (index, label) in labels.enumerated() {
            if label.frame.contains(location) {
                selectedIndex = index
                break
            }
        }

        return false
    }

    func displayNewSelectedIndex() {
        labels.forEach { $0.textColor = unselectedLabelColor }

        let selectedLabel = labels[selectedIndex]
        selectedLabel.textColor = selectedLabelColor

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            self.indicatorView.frame.origin.x = selectedLabel.frame.origin.x
        }, completion: nil)
    }

    func constrain(labels: [UIView]) {

        for (index, view) in labels.enumerated() {
            // top
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

            // bottom
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

            // right
            if index == labels.count - 1 {
                view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            } else {
                let nextView = labels[index + 1]
                view.rightAnchor.constraint(equalTo: nextView.leftAnchor).isActive = true
            }

            // left
            if index == 0 {
                view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            } else {
                let prevView = labels[index - 1]
                view.leftAnchor.constraint(equalTo: prevView.rightAnchor).isActive = true
            }

            // width
            if index != 0 {
                let firstView = labels[0]
                view.widthAnchor.constraint(equalTo: firstView.widthAnchor).isActive = true
            }
        }
    }
}

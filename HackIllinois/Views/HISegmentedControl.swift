//
//  HISegmentedControl.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/29/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HISegmentedControl: UIControl {

    // MARK: - Properties
    private(set) var items = ["Friday", "Saturday", "Sunday"]

    private(set) var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex(previousIndex: oldValue)
            sendActions(for: .valueChanged)
        }
    }

    private var labels = [UILabel]()
    private var font = UIFont.systemFont(ofSize: 13, weight: .medium)
    private var selectedLabelColor = HIColor.darkIndigo
    private var unselectedLabelColor = HIColor.darkIndigo

    private var indicatorView = UIView()
    private var indicatorViewColor = HIColor.hotPink
    private var indicatorViewHeight = CGFloat(3)

    private var bottomView = UIView()
    private var bottomViewColor = HIColor.hotPink
    private var bottomViewHeight = CGFloat(1)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()

        let indicatorViewWidth = frame.width / CGFloat(items.count)
        indicatorView.frame = CGRect(x: 0, y: frame.height - indicatorViewHeight, width: indicatorViewWidth, height: indicatorViewHeight)
        indicatorView.backgroundColor = indicatorViewColor

        bottomView.frame = CGRect(x: 0, y: frame.height - (2 * bottomViewHeight), width: frame.width, height: bottomViewHeight)
        bottomView.backgroundColor = bottomViewColor

        displayNewSelectedIndex(previousIndex: 0)
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

    // MARK: - Label Setup
    private func setupView() {
        setupLabels()
        insertSubview(indicatorView, at: 0)
        insertSubview(bottomView, at: 0)
    }

    private func setupLabels() {
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)
        items.indices.forEach { setupLabelForItem(at: $0) }
        constrain(labels: labels)
    }

    private func setupLabelForItem(at index: Int) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = font
        label.textColor = index == 0 ? selectedLabelColor : unselectedLabelColor
        label.text = items[index]
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        labels.append(label)
    }

    private func displayNewSelectedIndex(previousIndex: Int) {
        let previousLabel = labels[previousIndex]
        let selectedLabel = labels[selectedIndex]

        previousLabel.textColor = unselectedLabelColor
        selectedLabel.textColor = selectedLabelColor

        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8)
        animator.addAnimations {
            self.indicatorView.frame.origin.x = selectedLabel.frame.origin.x
        }
        animator.startAnimation()
    }

    private func constrain(labels: [UIView]) {

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

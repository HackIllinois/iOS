//
//  HISegmentedControl.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/29/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//
import Foundation
import UIKit

class HISegmentedControl: UIControl {

    // MARK: - Properties
    private(set) var items: [String]

    private(set) var selectedIndex: Int = 0 {
        didSet {
            if oldValue != selectedIndex {
                displayNewSelectedIndex(previousIndex: oldValue)
                sendActions(for: .valueChanged)
            }
        }
    }

    private var labels = [UILabel]()
    private var font = UIFont.systemFont(ofSize: 13, weight: .medium)

    private var indicatorView = UIView()
    private var indicatorViewHeight = CGFloat(3)

    private var bottomView = UIView()
    private var bottomViewHeight = CGFloat(1)

    // MARK: - Init
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        backgroundColor = HIAppearance.current.background
        labels.forEach {
            $0.textColor = HIAppearance.current.primary
            $0.backgroundColor = HIAppearance.current.background
        }
        bottomView.backgroundColor = HIAppearance.current.accent
        indicatorView.backgroundColor = HIAppearance.current.accent
    }

    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()

        let indicatorViewWidth = frame.width / CGFloat(items.count)
        indicatorView.frame = CGRect(x: 0, y: frame.height - indicatorViewHeight, width: indicatorViewWidth, height: indicatorViewHeight)
        bottomView.frame = CGRect(x: 0, y: frame.height - (2 * bottomViewHeight), width: frame.width, height: bottomViewHeight)

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
        addSubview(bottomView)
        addSubview(indicatorView)
    }

    private func setupLabels() {
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)
        items.indices.forEach { setupLabelForItem(at: $0) }
        constrain(labels: labels)
    }

    private func setupLabelForItem(at index: Int) {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font
        label.text = items[index]
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        labels.append(label)
    }

    private func displayNewSelectedIndex(previousIndex: Int) {
//        let previousLabel = labels[previousIndex]
        let selectedLabel = labels[selectedIndex]

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

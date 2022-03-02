//
//  HISegmentedControl.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/29/17.
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

    var selectedIndex: Int = 0 {
        didSet {
            didSetSelectedIndex(oldValue: oldValue)
        }
    }

    private var views = [UIView]()
    private var labels = [UILabel]()
    private let font = HIAppearance.Font.segmentedTitle

    private let viewPadding: CGFloat = 10
    private let indicatorCornerRadiusProp: CGFloat = 0.15

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
        backgroundColor <- \.clear
        labels.forEach {
            $0.textColor <- \.baseText
            $0.backgroundColor <- \.clear
        }

        indicatorView.backgroundColor <- \.segmentedBackground
        indicatorView.alpha = 0.3
    }

    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()

        let indicatorViewWidth = ((frame.width - viewPadding) / CGFloat(items.count) - viewPadding)
        indicatorView.frame = CGRect(x: viewPadding, y: 0, width: indicatorViewWidth, height: frame.height)
        indicatorView.layer.cornerRadius = frame.height * indicatorCornerRadiusProp
        indicatorView.layer.masksToBounds = true

        displayNewSelectedIndex()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        for (index, view) in views.enumerated() {
            if view.frame.contains(location) {
                selectedIndex = index
                break
            }
        }

        return false
    }

    // MARK: - Label Setup
    public func update(items: [String]) {
        self.items = items
        selectedIndex = 0
        setupLabels()
    }

    func setupView() {
        setupLabels()
        addSubview(indicatorView)
    }

    func setupLabels() {
        views.forEach { $0.removeFromSuperview() }
        views.removeAll(keepingCapacity: true)
        items.indices.forEach { setupViewForItem(at: $0) }
        constrain(views: views)
    }

    private func setupViewForItem(at index: Int) {
        let view = UIView()
        let label = UILabel()

        label.textAlignment = .center
        label.font = font
        label.text = items[index]
        label.textColor <- \.whiteText

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.constrain(to: view, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        view.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        views.append(view)
        labels.append(label)
    }

    func didSetSelectedIndex(oldValue: Int) {
        if oldValue != selectedIndex {
            displayNewSelectedIndex()
            sendActions(for: .valueChanged)
        }
    }

    func displayNewSelectedIndex() {
        let selectedView = views[selectedIndex]

        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8)
        animator.addAnimations {
            self.indicatorView.frame.origin.x = selectedView.frame.origin.x
        }
        animator.startAnimation()
    }

    private func constrain(views: [UIView]) {

        for (index, view) in views.enumerated() {

            // top and bottom
            view.constrain(to: self, topInset: 0, bottomInset: 0)

            // right
            if index == items.count - 1 {
                view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -viewPadding).isActive = true
            }

            // left
            if index == 0 {
                view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: viewPadding).isActive = true
            } else {
                let prevView = views[index - 1]
                view.leftAnchor.constraint(equalTo: prevView.rightAnchor, constant: viewPadding).isActive = true
            }

            // width
            if index != 0 {
                let firstView = views[0]
                view.widthAnchor.constraint(equalTo: firstView.widthAnchor).isActive = true
            }
        }
    }
}

//
//  HIScheduleSegmentedControl.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/7/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIScheduleSegmentedControl: HISegmentedControl {

    // MARK: - Properties
    private(set) var nums: [Int]

    private var views = [UIView]()
    private var titleLabels = [UILabel]()
    private var numberLabels = [UILabel]()

    private let titleFont = HIAppearance.Font.segmentedTitle
    private let titleFontPad = HIAppearance.Font.scheduleSegmentedPad
    private let numberFont = HIAppearance.Font.segmentedNumberText
    private let numberFontPad = HIAppearance.Font.scheduleSegmentedNumberPad

    private let viewPadding: CGFloat = 65
    private let indicatorCornerRadiusProp: CGFloat = 0.15

    private var indicatorView = UIImageView(image: #imageLiteral(resourceName: "Indicator"))

    // MARK: - Init
    init(titles: [String], nums: [Int]? = nil) {
        self.nums = nums == nil ? [Int]() : nums!
        super.init(items: titles)

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
    @objc override func refreshForThemeChange() {
        backgroundColor <- \.clear
        titleLabels.forEach {
            $0.textColor <- \.white
            $0.backgroundColor <- \.clear
        }

        numberLabels.forEach {
            $0.textColor <- \.white
            $0.backgroundColor <- \.clear
        }
    }

    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        var indicatorConstant: CGFloat = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            indicatorConstant = 50.0
        }
        let indicatorViewWidth = ((frame.width - viewPadding) / CGFloat(items.count) - viewPadding)
        indicatorView.frame = CGRect(x: viewPadding, y: 68 + indicatorConstant, width: indicatorViewWidth, height: 4 + (indicatorConstant / 6))
        indicatorView.layer.masksToBounds = true
        indicatorView.contentMode = .scaleAspectFit
        indicatorView.contentMode = .center
        displayNewSelectedIndex()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        for (index, view) in views.enumerated() where view.frame.contains(location) {
                selectedIndex = index
                break
        }

        return false
    }

    // MARK: - View Setup
    override func setupView() {
        setupLabels()
        addSubview(indicatorView)
    }

    override func setupLabels() {
        views.forEach { $0.removeFromSuperview() }
        views.removeAll(keepingCapacity: true)
        items.indices.forEach { setupViewForItem(at: $0) }
        constrain(views: views)
    }

    private func setupViewForItem(at index: Int) {
        let view = UIView()
        let titleLabel = UILabel()
        let numberLabel = UILabel()

        titleLabel.textAlignment = .center
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = titleFontPad
            numberLabel.font = numberFontPad
        } else {
            titleLabel.font = titleFont
            numberLabel.font = numberFont
        }
        titleLabel.text = items[index]
        titleLabel.textColor <- \.whiteText

        numberLabel.textAlignment = .center
        numberLabel.text = index < nums.count ? (nums[index] % 10 == nums[index] ? "0" : "") + "\(nums[index])" : "00"
        numberLabel.textColor <- \.whiteText

        view.addSubview(titleLabel)
        view.addSubview(numberLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        var segmentedControlConstant = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            segmentedControlConstant = 24.0
        }
        titleLabel.constrain(to: view, topInset: 5, trailingInset: 0, leadingInset: 0)
        numberLabel.constrain(to: view, trailingInset: 0, bottomInset: -4, leadingInset: 0)
        numberLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: segmentedControlConstant).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: numberLabel.heightAnchor).isActive = true

        view.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        numberLabel.isUserInteractionEnabled = false

        addSubview(view)
        views.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        titleLabels.append(titleLabel)
        numberLabels.append(numberLabel)
    }

    override func didSetSelectedIndex(oldValue: Int) {
        if oldValue != selectedIndex {
            displayNewSelectedIndex()
            sendActions(for: .valueChanged)
        }
    }

    override func displayNewSelectedIndex() {
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

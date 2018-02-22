//
//  HIButton.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIButton: UIButton {
    // MARK: - Types
    enum Style: Equatable {
        case standard(title: String?)
        case async(title: String?)
        case menu(title: String?, tag: Int)
        case icon(image: UIImage)

        var rawValue: Int {
            switch self {
            case .standard: return 0
            case .async: return 1
            case .menu: return 2
            case .icon: return 3
            }
        }

        static func == (lhs: HIButton.Style, rhs: HIButton.Style) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }

    // MARK: - Properties
    let style: Style
    var activityIndicator: UIActivityIndicatorView?

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)

        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchDragEnter), for: .touchDragEnter)
        addTarget(self, action: #selector(handleTouchDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)

        translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .standard(let title):
            layer.cornerRadius = 8
            setTitle(title, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 15)

        case .async(let title):
            layer.cornerRadius = 8
            setTitle(title, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 15)

            let activityIndicator = UIActivityIndicatorView()
            addSubview(activityIndicator)
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            self.activityIndicator = activityIndicator

        case .menu(let title, let tag):
            contentHorizontalAlignment = .left
            setTitle(title, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.tag = tag

        case .icon(let image):
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            setImage(templateImage, for: .normal)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        setTitleColor(HIApplication.Palette.current.primary, for: .normal)

        switch style {
        case .standard:
            backgroundColor = HIApplication.Palette.current.actionBackground

        case .async:
            backgroundColor = HIApplication.Palette.current.actionBackground
            activityIndicator?.tintColor = HIApplication.Palette.current.accent

        case .menu:
            backgroundColor = HIApplication.Palette.current.background
            setTitleColor(HIApplication.Palette.current.primary, for: .normal)

        case .icon:
            backgroundColor = HIApplication.Palette.current.background
            tintColor = HIApplication.Palette.current.accent
        }
    }

    // MARK: - API
    func setAsyncTask(running: Bool) {
        guard case let .async(title) = style else {
            fatalError("setAsyncTask(_:) can only be used on an HIButton with Style async.")
        }
        if running {
            isEnabled = false
            setTitle(nil, for: .normal)
            backgroundColor = UIColor.lightGray
            activityIndicator?.startAnimating()
        } else {
            isEnabled = true
            setTitle(title, for: .normal)
            backgroundColor = HIApplication.Palette.current.actionBackground
            activityIndicator?.stopAnimating()
        }
    }

    // MARK: - Touch Animations
    private var animator: UIViewPropertyAnimator?

    @objc private func handleTouchDown() {
        animator?.stopAnimation(true)
        setTouchStyle(down: true)
    }

    @objc private func handleTouchDragEnter() {
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) { [weak self] in
            self?.setTouchStyle(down: true)
        }
        animator?.startAnimation()
    }

    @objc private func handleTouchDragExit() {
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) { [weak self] in
            self?.setTouchStyle(down: false)
        }
        animator?.startAnimation()
    }

    @objc private func handleTouchUpInside() {
        animator?.stopAnimation(true)
        setTouchStyle(down: false)
    }

    private func setTouchStyle(down: Bool) {
        if down {
            imageView?.alpha = 0.25
            titleLabel?.alpha = 0.25
        } else {
            imageView?.alpha = 1.0
            titleLabel?.alpha = 1.0
        }
    }
}

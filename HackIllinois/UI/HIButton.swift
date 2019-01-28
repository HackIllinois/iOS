//
//  HIButton.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIButton: UIButton {
    // MARK: - Types
    enum Style {
        case content
        case plain
        case standard
        case menu(tag: Int)
    }

    // MARK: - Properties
    let style: Style

    var title: String?
    var activeImage: UIImage?
    var inactiveImage: UIImage?

    var isActive: Bool = false {
        willSet {
            guard newValue != isActive else { return }
            let newImage = newValue ? activeImage : inactiveImage
            setImage(newImage, for: .normal)
        }
    }

    var isRunning: Bool = false {
        willSet {
            guard newValue != isRunning else { return }
            if newValue {
                isEnabled = false
                setTitle(nil, for: .normal)
                backgroundColor = UIColor.lightGray
                activityIndicator.startAnimating()
            } else {
                isEnabled = true
                setTitle(title, for: .normal)
                backgroundColor = HIAppearance.current.actionBackground
                activityIndicator.stopAnimating()
            }
        }
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        self.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activityIndicator
    }()

    // MARK: - Init
    init(style: Style, additionalConfiguration: ((HIButton) -> Void)? = nil) {
        self.style = style
        super.init(frame: .zero)
        additionalConfiguration?(self)

        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchDragEnter), for: .touchDragEnter)
        addTarget(self, action: #selector(handleTouchDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)

        translatesAutoresizingMaskIntoConstraints = false
        adjustsImageWhenHighlighted = false

        switch style {
        case .content, .plain:
            titleLabel?.font = UIFont.systemFont(ofSize: 15)

        case .standard:
            layer.cornerRadius = 8
            titleLabel?.font = UIFont.systemFont(ofSize: 15)

        case .menu(let tag):
            contentHorizontalAlignment = .left
            titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.tag = tag
        }

        setTitle(title, for: .normal)
        setImage(inactiveImage, for: .normal)

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
        setTitleColor(HIAppearance.current.primary, for: .normal)

        activityIndicator.tintColor = HIAppearance.current.accent
        tintColor = HIAppearance.current.accent

        switch style {
        case .content:
            backgroundColor = HIAppearance.current.contentBackground

        case .plain:
            backgroundColor = HIAppearance.current.background

        case .standard:
            backgroundColor = HIAppearance.current.actionBackground

        case .menu:
            backgroundColor = HIAppearance.current.background
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

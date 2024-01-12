//
//  HIButton.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIButton: UIButton {
    // MARK: - Properties
    var title: String?
    var activeImage: UIImage?
    var baseImage: UIImage?

    var titleHIColor: HIColor?
    var tintHIColor: HIColor?
    var backgroundHIColor: HIColor?

    var isActive: Bool = false {
        willSet {
            guard newValue != isActive else { return }
            let newImage = newValue ? activeImage : baseImage
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
                backgroundColor <- backgroundHIColor
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
    init(additionalConfiguration: ((HIButton) -> Void)? = nil) {
        super.init(frame: .zero)
        additionalConfiguration?(self)

        translatesAutoresizingMaskIntoConstraints = false
        adjustsImageWhenHighlighted = false

        setTitle(title, for: .normal)
        setImage(baseImage, for: .normal)

        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchDragEnter), for: .touchDragEnter)
        addTarget(self, action: #selector(handleTouchDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)

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
        setTitleColor(titleHIColor?.value, for: .normal)
        activityIndicator.tintColor <- tintHIColor
        tintColor <- tintHIColor
        backgroundColor <- backgroundHIColor
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

extension HIButton {
    func toBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(customView: self)
    }
}

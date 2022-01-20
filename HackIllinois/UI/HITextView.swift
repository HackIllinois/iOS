//
//  HITextView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/28/21.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITextView: UITextView {

    // MARK: - Properties
    var textHIColor: HIColor?
    var tintHIColor: HIColor?
    var backgroundHIColor: HIColor?

    // MARK: - Init
    init() {
        super.init(frame: .zero, textContainer: nil)

        font = HIAppearance.Font.profileTier.withSize(18)
        textHIColor = \.whiteTagFont
        tintHIColor = \.whiteTagFont
        backgroundHIColor = \.clear

        self.returnKeyType = .default
        self.delegate = self
        enablesReturnKeyAutomatically = true
        translatesAutoresizingMaskIntoConstraints = false
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
        textColor <- textHIColor
        tintColor <- tintHIColor
        backgroundColor <- backgroundHIColor
    }

    func addBottomBorder() {
        let bottomView = HIView { (view) in
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundHIColor = \.whiteTagFont
            view.alpha = 0.5
        }

        self.superview?.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}

// MARK: - UITextViewDelegate
extension HITextView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

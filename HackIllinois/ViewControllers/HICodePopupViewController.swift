//
//  HICodePopupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

class HICodePopupViewController: UIViewController {
    // MARK: Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.titleHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
    private let submitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.interestBackground
        $0.title = "Submit"
        $0.titleLabel?.font = HIAppearance.Font.loginSelection
        $0.titleLabel?.baselineAdjustment = .alignCenters
    }
}

// MARK: Actions
extension HICodePopupViewController {
    @objc func didSelectClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSelectBackground(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UIViewController
extension HICodePopupViewController {
    
}

//
//  HIGroupPopupViewController.swift
//  HackIllinois
//
//  Created by the HackIllinois Team on 2/1/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import HIAPI

class HIGroupPopupViewController: HIBaseViewController {
    // MARK: Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.titleHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
    private let popupBackground = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.buttonViewBackground
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
}

// MARK: Actions
extension HIGroupPopupViewController {
    @objc func didSelectClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewController
extension HIGroupPopupViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(popupBackground)
        view.addSubview(containerView)
        
        popupBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        popupBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        popupBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        popupBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        containerView.addSubview(exitButton)
        
        
    }
}


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
        $0.backgroundHIColor = \.buttonViewBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.titleHIColor = \.qrTint
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "CloseButton")
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }/*
    private let popupBackground = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.buttonViewBackground
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }*/
    private let button1 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "AWS"
    }
    private let button2 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "C++"
    }
    private let button3 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Project Management"
    }
    private let button4 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Scikit-Learn"
    }
    private let button5 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Python"
    }
    private let button6 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Docker"
    }
    private let button7 = HIButton {
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Java"
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

    @objc func didSelectBackground(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewController
extension HIGroupPopupViewController {
    override func loadView() {
        super.loadView()
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        let selectSortLabel = HILabel(style: .sortText)
        selectSortLabel.text = "Select Skills"

        //view.addSubview(popupBackground)
        view.addSubview(containerView)
        /*
        popupBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        popupBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        popupBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        popupBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        */
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        containerView.addSubview(exitButton)
        containerView.addSubview(contentStackView)

        exitButton.constrain(to: containerView, topInset: 18, leadingInset: 22)

        contentStackView.addSubview(selectSortLabel)
        contentStackView.addSubview(button1)
        contentStackView.addSubview(button2)
        contentStackView.addSubview(button3)
        contentStackView.addSubview(button4)
        contentStackView.addSubview(button5)
        contentStackView.addSubview(button6)
        contentStackView.addSubview(button7)
    }
}

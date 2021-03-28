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
        $0.titleLabel?.font = HIAppearance.Font.detailTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.layer.cornerRadius = 15
    }
    private let textField = HITextField {
        $0.placeholder = "Type your code here"
        $0.textAlignment = .center
        $0.keyboardAppearance = .dark
        $0.font = HIAppearance.Font.profileDescription
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    private let viewLabel = HILabel {
        $0.text = "Collect your points!"
        $0.font = HIAppearance.Font.detailTitle
        $0.backgroundHIColor = \.qrBackground
    }
    private let popupImage = UIImage(named: "CodePopup")
    private let codeImage = HIImageView {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    private let bottomLine = HIView {
        $0.backgroundHIColor = \.black
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
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        codeImage.image = popupImage

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)

        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        containerView.addSubview(exitButton)
        exitButton.constrain(to: containerView, topInset: 8, leadingInset: 8)

        containerView.addSubview(codeImage)
        codeImage.constrain(to: containerView, topInset: 15)
        codeImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        codeImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        codeImage.constrain(width: 125, height: 125)

        containerView.addSubview(viewLabel)
        viewLabel.topAnchor.constraint(equalTo: codeImage.bottomAnchor, constant: 20).isActive = true
        viewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        containerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 30).isActive = true
        textField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        containerView.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 10).isActive = true
        //bottomLine.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true

        containerView.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 10).isActive = true
        //submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4).isActive = true
    }
}

// MARK: - UIGestureRecognizerDelegate
extension HICodePopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HICodePopupViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopinAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopoutAnimator()
    }
}

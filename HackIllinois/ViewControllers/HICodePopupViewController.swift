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
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(didSelectSubmit(_:)), for: .touchUpInside)
    }
    private let codeField = HITextField {
        $0.placeholder = "Type your code here"
        $0.textAlignment = .center
        $0.keyboardAppearance = .dark
        $0.font = HIAppearance.Font.profileDescription
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    private let bottomCodeFieldLine = CALayer()
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

    @objc func didSelectSubmit(_ sender: UIButton) {
        if let code = codeField.text {
            HIAPI.EventService.checkIn(code: code)
            .onCompletion { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
            .authorize(with: HIApplicationStateController.shared.user)
            .launch()
        }
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: UIViewController
extension HICodePopupViewController {
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        codeField.text = ""
        self.dismiss(animated: true, completion: nil)
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        codeImage.image = popupImage

        let backgroundGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        backgroundGestureRecognizer.delegate = self
        view.addGestureRecognizer(backgroundGestureRecognizer)

        let containerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        containerView.addGestureRecognizer(containerGestureRecognizer)

        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 284).isActive = true
        containerView.addSubview(exitButton)
        exitButton.constrain(to: containerView, topInset: 8, leadingInset: 8)

        containerView.addSubview(codeImage)
        codeImage.constrain(to: containerView, topInset: 15)
        codeImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        codeImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        codeImage.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true
        codeImage.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true

        containerView.addSubview(viewLabel)
        viewLabel.topAnchor.constraint(equalTo: codeImage.bottomAnchor, constant: 10).isActive = true
        viewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        codeField.autocorrectionType = .no
        containerView.addSubview(codeField)
        codeField.leadingAnchor.constraint(equalTo: viewLabel.leadingAnchor, constant: -20).isActive = true
        codeField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        containerView.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 25).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    override func viewDidLayoutSubviews() {
        bottomCodeFieldLine.removeFromSuperlayer()
        bottomCodeFieldLine.frame = CGRect(x: 0.0, y: codeField.frame.height + 10, width: codeField.frame.width, height: 1.0)
        bottomCodeFieldLine.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.4470588235, alpha: 1)
        codeField.borderStyle = UITextField.BorderStyle.none
        codeField.layer.addSublayer(bottomCodeFieldLine)
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

//
//  HICheckInScannerViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/4/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import AVKit
import APIManager
import HIAPI

class HICheckInScannerViewController: HIBaseScannerViewController {
    private let containerView = HIView {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.baseBackground
    }
    private let contentView = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let titleLabel = HILabel {
        $0.backgroundHIColor = \.contentBackground
        $0.textHIColor = \.baseText
        $0.font = HIAppearance.Font.contentTitle
        $0.text = "RSVP OVERRIDE"
    }
    private let subtitleLabel = HILabel {
        $0.backgroundHIColor = \.contentBackground
        $0.textHIColor = \.baseText
        $0.numberOfLines = 0
        $0.font = HIAppearance.Font.contentText
        $0.text = "Warning, this switch allows students that have not RSVP'ed to check in."
    }
    private let overrideSwitch = UISwitch(frame: .zero)
}

// MARK: - UIViewController
extension HICheckInScannerViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(containerView)
        containerView.constrain(to: view, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        containerView.addSubview(contentView)
        contentView.constrain(to: containerView, topInset: 8, trailingInset: -8, leadingInset: 8)
        contentView.constrain(to: containerView.safeAreaLayoutGuide, bottomInset: -8)

        overrideSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overrideSwitch)
        overrideSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        overrideSwitch.constrain(to: contentView.safeAreaLayoutGuide, trailingInset: -12)

        contentView.addSubview(titleLabel)
        titleLabel.trailingAnchor.constraint(equalTo: overrideSwitch.leadingAnchor, constant: -8).isActive = true
        titleLabel.constrain(to: contentView.safeAreaLayoutGuide, topInset: 8, leadingInset: 12)

        contentView.addSubview(subtitleLabel)
        subtitleLabel.trailingAnchor.constraint(equalTo: overrideSwitch.leadingAnchor, constant: -8).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.constrain(to: contentView.safeAreaLayoutGuide, bottomInset: -8, leadingInset: 12)
    }
}

// MARK: - UINavigationItem Setup
extension HICheckInScannerViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "CHECK IN"
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension HICheckInScannerViewController {
    override func found(user id: String) {
        AudioServicesPlaySystemSound(1004)
        hapticGenerator.notificationOccurred(.success)

        let alert = UIAlertController(title: "Checking user...", message: id, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)

        HIAPI.CheckInService.checkIn(id: id, override: overrideSwitch.isOn)
        .onCompletion { (result) in
            DispatchQueue.main.async { [weak self] in
                do {
                    let (simpleRequest, _) = try result.get()
                    if let error = simpleRequest.message {
                        alert.title = "Uh oh"
                        alert.message = error
                    } else {
                        alert.title = "Success"
                        alert.message = "Everything is good to go."
                    }
                } catch APIRequestError.invalidHTTPReponse(code: let code, description: let description) {
                    alert.title = "Bad Response"
                    alert.message = "HackIllinois API returned \(code)\n\(description.capitalized)"
                } catch {
                    alert.title = "Unknown Error"
                    alert.message = String(describing: error)
                }

                alert.addAction(
                    UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                        self?.respondingToQRCodeFound = true
                    }
                )
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}

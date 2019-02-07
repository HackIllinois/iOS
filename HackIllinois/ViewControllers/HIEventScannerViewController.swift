//
//  HIEventScannerViewController.swift
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

class HIEventScannerViewController: HIBaseScannerViewController {
    var event: Event?
}

// MARK: - UINavigationItem Setup
extension HIEventScannerViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "EVENT SCANNER"
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension HIEventScannerViewController {
    override func found(user id: String) {
        guard let event = event else {
            respondingToQRCodeFound = true
            dismiss(animated: true, completion: nil)
            return
        }
        AudioServicesPlaySystemSound(1004)
        hapticGenerator.notificationOccurred(.success)

        let alert = UIAlertController(title: "Checking user...", message: id, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)

        HIAPI.TrackingService.track(name: event.name, id: id)
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

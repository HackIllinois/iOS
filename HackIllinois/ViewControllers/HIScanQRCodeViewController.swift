//
//  HIScanQRCodeViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/9/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import Combine
import AVKit
import CoreData
import APIManager
import HIAPI
import SwiftUI

class HIScanQRCodeViewController: HIBaseViewController {
    private var captureSession: AVCaptureSession?
    private let containerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.baseBackground
    }
    private let previewView = HIView {
        $0.backgroundHIColor = \.baseBackground
    }
    private var previewLayer: AVCaptureVideoPreviewLayer?
    let hapticGenerator = UINotificationFeedbackGenerator()
    private let pickerView = UIPickerView()
    private var loadFailed = false
    var respondingToQRCodeFound = true
    private let closeButton = HIButton {
        $0.tintHIColor = \.action
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "CloseButton")
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
    }
    private let errorView = HIErrorView(style: .codePopup)
    private var selectedEventId = ""
    private var cancellables = Set<AnyCancellable>()
    var currentUserID = ""
    var currentUserName = ""
    var dietaryString = ""
}

// MARK: - UIViewController
extension HIScanQRCodeViewController {
    override func loadView() {
        super.loadView()
        print("General QR scanner")
        guard let user = HIApplicationStateController.shared.user else { return }
        if HIApplicationStateController.shared.isGuest && !user.roles.contains(.STAFF) {
            let background = #imageLiteral(resourceName: "ProfileBackground")
            let imageView: UIImageView = UIImageView(frame: view.bounds)
            view.addSubview(imageView)
            view.sendSubviewToBack(imageView)
            layoutErrorView()
        } else {
            view.addSubview(containerView)
            view.bringSubviewToFront(containerView)
            containerView.constrain(to: view, topInset: 0, bottomInset: 0)
            containerView.constrain(to: view, trailingInset: 0, leadingInset: 0)
            containerView.addSubview(previewView)
            setupCaptureSession()
            if user.roles.contains(.STAFF) {
                let observable = HIStaffButtonViewObservable()
                observable.$selectedEventId.sink { eventId in
                    self.selectedEventId = eventId
                }.store(in: &cancellables)
                let staffButtonController = UIHostingController(rootView: HIStaffButtonView(observable: observable))
                addChild(staffButtonController)
                staffButtonController.view.backgroundColor = .clear
                staffButtonController.view.frame = CGRect(x: 0, y: 100, width: Int(view.frame.maxX), height: 600)
                view.addSubview(staffButtonController.view)
            }
        }
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        closeButton.constrain(width: 60, height: 60)
        closeButton.imageView?.contentMode = .scaleToFill
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loadFailed {
            presentErrorController(
                title: "Scanning not supported",
                message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                dismissParentOnCompletion: true
            )
        } else if captureSession?.isRunning == false {
            previewLayer?.frame = view.layer.bounds
            DispatchQueue.main.async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            DispatchQueue.main.async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (_) in
            self?.setFrameForPreviewLayer()
        }, completion: nil)
    }
    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

// MARK: - Actions
extension HIScanQRCodeViewController {
    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - HIErrorViewDelegate
extension HIScanQRCodeViewController: HIErrorViewDelegate {
    func didSelectErrorLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Log Out", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .logoutUser, object: nil)
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension HIScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        let metadataOutput = AVCaptureMetadataOutput()
        guard
            let captureSession = captureSession,
            let videoCaptureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
            captureSession.canAddInput(videoInput),
            captureSession.canAddOutput(metadataOutput) else {
            loadFailed = true
            return
        }
        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        setFrameForPreviewLayer()
        previewView.layer.addSublayer(previewLayer)
    }

    func setFrameForPreviewLayer() {
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = previewView.layer.bounds
        guard previewLayer.connection?.isVideoOrientationSupported == true else { return }
#warning("Not Tested")
        let interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch interfaceOrientation {
        case .portrait, .unknown:
            previewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeRight
        case .none:
            break
        @unknown default:
            previewLayer.connection?.videoOrientation = .portrait
        }
    }

    func handleCheckInAlert(status: String, newPoints: Int) {
        var alertTitle = ""
        var alertMessage = ""
        switch status {
        case "Success":
            alertTitle = "\n\nSuccess!"
            alertMessage = "\nYou received \(newPoints) points!"
        case "InvalidCode":
            alertTitle = "\n\nError!"
            alertMessage = "\nThis code doesn't seem to be correct."
            self.respondingToQRCodeFound = true
        case "InvalidTime":
            alertTitle = "\n\nError!"
            alertMessage = "\nMake sure you have the right time."
            self.respondingToQRCodeFound = true
        case "AlreadyCheckedIn":
            alertTitle = "\n\nError!"
            alertMessage = "\nLooks like you're already checked in."
            self.respondingToQRCodeFound = true
        default:
            alertTitle = "\n\nError!"
            alertMessage = "\nSomething isn't quite right."
            self.respondingToQRCodeFound = true
        }
        // Create custom alert for attendee check in functionality
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let titleFont = UIFont(name: "MontserratRoman-Bold", size: 22)
        let messageFont = UIFont(name: "MontserratRoman-Medium", size: 16)
        let titleColor = #colorLiteral(red: 0.337254902, green: 0.1411764706, blue: 0.06666666667, alpha: 1)
        let messageColor = #colorLiteral(red: 0.337254902, green: 0.1411764706, blue: 0.06666666667, alpha: 1)
        let attributedTitle = NSAttributedString(string: alertTitle, attributes: [NSAttributedString.Key.font: titleFont as Any, NSAttributedString.Key.foregroundColor: titleColor])
        let attributedMessage = NSAttributedString(string: alertMessage, attributes: [NSAttributedString.Key.font: messageFont as Any, NSAttributedString.Key.foregroundColor: messageColor])
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        // Create image view
        let imageView = UIImageView(image: UIImage(named: "Treasure Chest"))
        imageView.contentMode = .scaleAspectFit
        alert.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: alert.view.topAnchor, constant: -5).isActive = true
        if alertTitle == "Success!" {
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    //self.dismiss(animated: true, completion: nil)
                    //Dismisses view controller
                    //self.didSelectCloseButton(self.closeButton)
                    NotificationCenter.default.post(name: .qrCodeSuccessfulScan, object: nil)
                }))
        } else {
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.registerForKeyboardNotifications()
                }))
        }
        self.present(alert, animated: true, completion: nil)

    }

    func handleStaffCheckInAlert(status: String) {
        var alertTitle = ""
        var alertMessage = ""
        switch status {
        case "Success":
            alertTitle = "Success!"
            alertMessage = "Name: \(currentUserName)\n Diet: \(dietaryString)"
        case "InvalidEventId":
            alertTitle = "Error!"
            alertMessage = "Invalid Event ID"
            self.respondingToQRCodeFound = true
        case "BadUserToken":
            alertTitle = "Error!"
            alertMessage = "BadUserToken"
            self.respondingToQRCodeFound = true
        case "AlreadyCheckedIn":
            alertTitle = "Error!"
            alertMessage = "Looks like you're already checked in."
            self.respondingToQRCodeFound = true
        default:
            alertTitle = "Error!"
            alertMessage = "Something isn't quite right."
            self.respondingToQRCodeFound = true
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if alertTitle == "Success!" {
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    //Dismisses view controller
                    self.didSelectCloseButton(self.closeButton)
                    NotificationCenter.default.post(name: .qrCodeSuccessfulScan, object: nil)
                }))
        } else {
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.registerForKeyboardNotifications()
                }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    func staffCheckIn(userID: String, status: String) {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.RegistrationService.getAttendeeRegistrationUserID(userID: userID)
            .onCompletion { result in
                do {
                    let (apiAttendeeContainer, _) = try result.get()
                    DispatchQueue.main.async { [self] in
                        dietaryString = ""
                        for diet in apiAttendeeContainer.dietary ?? [] {
                            dietaryString += diet + ", "
                        }
                        guard let first = apiAttendeeContainer.firstName else { return }
                        guard let last = apiAttendeeContainer.lastName else { return }
                        currentUserName = first + " " + last
                        self.handleStaffCheckInAlert(status: status)
                    }
                } catch {
                    print("An error has occurred \(error)")
                }
            }
            .authorize(with: user)
            .launch()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard respondingToQRCodeFound else { return }
        let meta = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        let code = meta?.stringValue ?? ""
        guard let user = HIApplicationStateController.shared.user else { return }
        let staffToken = user.token
        print("staff token is:", staffToken)
        if user.roles.contains(.STAFF) {
            if selectedEventId != "" {
                print("event id is", selectedEventId)
                if let range = code.range(of: "userToken=") {
                    let userToken = code[range.upperBound...]
                    respondingToQRCodeFound = false
                    HIAPI.StaffService.recordUserAttendance(userToken: String(userToken), staffToken: String(staffToken), eventId: selectedEventId)
                        .onCompletion { result in
                            do {
                                let (codeResult, _) = try result.get()
                                print("code result", codeResult)
                                DispatchQueue.main.async { [self] in
                                    handleStaffCheckInAlert(status: "Success")
                                }
                            } catch {
                                print(error, error.localizedDescription)
                                self.handleStaffCheckInAlert(status: error.localizedDescription)
                            }
                            sleep(2)
                        }
                        .authorize(with: HIApplicationStateController.shared.user)
                        .launch()
                    }
                }
        } else {
            respondingToQRCodeFound = false
            HIAPI.EventService.checkIn(code: code)
                .onCompletion { result in
                    do {
                        let (codeResult, _) = try result.get()
                        let status = codeResult.status
                        DispatchQueue.main.async {
                            self.handleCheckInAlert(status: codeResult.status, newPoints: codeResult.newPoints)
                        }
                    } catch {
                        print(error, error.localizedDescription)
                    }
                    // Set respondingToQRCodeFound back to true
                    self.respondingToQRCodeFound = true
                    sleep(2)
                }
                .authorize(with: HIApplicationStateController.shared.user)
                .launch()
        }
    }
    func decode(_ token: String) -> [String: AnyObject]? {
            let string = token.components(separatedBy: ".")
            if string.count == 1 { return nil }
            let toDecode = string[1] as String
            var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
            stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
            switch stringtoDecode.utf16.count % 4 {
            case 2: stringtoDecode = "\(stringtoDecode)=="
            case 3: stringtoDecode = "\(stringtoDecode)="
            default: // nothing to do stringtoDecode can stay the same
                print("")
            }
            let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
            let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)
            var values: [String: AnyObject]?
            if let string = base64DecodedString {
                if let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) {
                    values = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
                }
            }
            return values
        }
}

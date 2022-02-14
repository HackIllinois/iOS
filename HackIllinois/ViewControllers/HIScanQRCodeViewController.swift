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
import AVKit
import CoreData
import APIManager
import HIAPI

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
        $0.activeImage = #imageLiteral(resourceName: "DarkCloseButton")
        $0.baseImage = #imageLiteral(resourceName: "DarkCloseButton")
    }
    private let errorView = HIErrorView(style: .codePopup)
}

// MARK: - UIViewController
extension HIScanQRCodeViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        closeButton.constrain(width: 60, height: 60)
        closeButton.imageView?.contentMode = .scaleToFill
        if HIApplicationStateController.shared.isGuest {
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
        }
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

        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .unknown:
            previewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeRight
        @unknown default:
            previewLayer.connection?.videoOrientation = .portrait
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard respondingToQRCodeFound else { return }
        let meta = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        let code = meta?.stringValue ?? ""
        respondingToQRCodeFound = false
        HIAPI.EventService.checkIn(code: code)
            .onCompletion { result in
                do {
                    let (codeResult, _) = try result.get()
                    let newPoints = codeResult.newPoints
                    let status = codeResult.status
                    DispatchQueue.main.async {
                        var alertTitle = ""
                        var alertMessage = ""
                        switch status {
                        case "Success":
                            alertTitle = "Success!"
                            alertMessage = "You received \(newPoints) points!"
                        case "InvalidCode":
                            alertTitle = "Error!"
                            alertMessage = "This code doesn't seem to be correct."
                            self.respondingToQRCodeFound = true
                        case "InvalidTime":
                            alertTitle = "Error!"
                            alertMessage = "Make sure you have the right time."
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
                } catch {
                    print(error, error.localizedDescription)
                }
            }
            .authorize(with: HIApplicationStateController.shared.user)
            .launch()
    }
}

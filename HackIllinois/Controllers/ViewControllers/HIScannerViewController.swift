//
//  HIScannerViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/26/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import APIManager

class HIScannerViewController: HIBaseViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let hapticGenerator = UINotificationFeedbackGenerator()

    var loadFailed = false
    var respondingToQRCodeFound = true

    var lookingUpUserAlertController: UIAlertController?
    var adminEventViewController = HIScannerViewController()
}

// MARK: - UIViewController
extension HIScannerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loadFailed {
            presentErrorController(
                title: "Scanning not supported",
                message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                dismissParentOnCompletion: false
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
        var rightNavigationItem: UIBarButtonItem?
        if HIApplicationStateController.shared.user?.permissions == .admin {
            rightNavigationItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAdminEventViewController))
        }
        navigationItem.rightBarButtonItem = rightNavigationItem
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            DispatchQueue.main.async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - Actions
extension HIScannerViewController {
    @objc func presentAdminEventViewController() {
        navigationController?.pushViewController(adminEventViewController, animated: true)
    }
}

// MARK: - UINavigationItem Setup
extension HIScannerViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "SCANNER"
    }
}

// MARK: UINavigationControllerDelegate
extension HIScannerViewController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension HIScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        let metadataOutput = AVCaptureMetadataOutput()

        guard
            let captureSession = captureSession,
            let videoCaptureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
            captureSession.canAddInput(videoInput),
            captureSession.canAddOutput(metadataOutput)
            else {
                loadFailed = true
                return
        }

        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard respondingToQRCodeFound else { return }
        if let code = (metadataObjects.first as? AVMetadataMachineReadableCodeObject)?.stringValue {
            found(code: code)
        }
    }

    func found(code: String) {
        guard let url = URL(string: code),
            url.scheme == "hackillinois",
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems,
            let idString = queryItems.first(where: { $0.name == "id" })?.value,
            let id = Int(idString),
            let identifier = queryItems.first(where: { $0.name == "identifier" })?.value else { return }

        AudioServicesPlaySystemSound(1004)
        hapticGenerator.notificationOccurred(.success)
        respondingToQRCodeFound = false

        let lookingUpUserAlertController = UIAlertController(title: "Checking user...", message: identifier, preferredStyle: .alert)
        self.lookingUpUserAlertController = lookingUpUserAlertController
        present(lookingUpUserAlertController, animated: true, completion: nil)

        HITrackingService.track(id: id)
        .onCompletion { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self, let alert = strongSelf.lookingUpUserAlertController else { return }
                switch result {
                case .success(let successContainer):
                    if let error = successContainer.error {
                        switch error.type {
                        case "InvalidTrackingStateError", "InvalidParameterError":
                            alert.title = "Error"
                        default:
                            alert.title = "Unknown Error"
                        }
                    } else {
                        alert.title = "Success"
                    }
                    alert.message = successContainer.error?.message
                case .cancellation:
                    alert.title = "Cancelled"
                    alert.message = nil
                case .failure(let error):
                    alert.title = "Unknown Error"
                    alert.message = error.localizedDescription
                }

                alert.addAction(
                    UIAlertAction(title: "Ok", style: .default) { _ in
                        strongSelf.respondingToQRCodeFound = true
                        strongSelf.lookingUpUserAlertController = nil
                    }
                )
            }
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }
}

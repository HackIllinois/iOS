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

class HIScannerViewController: HIBaseViewController {
    var captureSession: AVCaptureSession?
    let hapticGenerator = UINotificationFeedbackGenerator()

    var loadFailed = false
    var respondingToQRCodeFound = true
}

// MARK: - UIViewController
extension HIScannerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            DispatchQueue.main.async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loadFailed {
            presentErrorController(
                title: "Scanning not supported",
                message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                dismissParentOnCompletion: false
            )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if captureSession?.isRunning == true {
            DispatchQueue.main.async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
        super.viewWillDisappear(animated)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard respondingToQRCodeFound else { return }
        if let qrString = (metadataObjects.first as? AVMetadataMachineReadableCodeObject)?.stringValue {
            AudioServicesPlaySystemSound(1004)
            hapticGenerator.notificationOccurred(.success)
            found(code: qrString)
        }
    }

    func found(code: String) {
        print(code)
        // validateCode (user_id=000)

        // pause scanner
        respondingToQRCodeFound = false

        let userDetailViewController = HIUserDetailViewController()
//        userDetailViewController.delegate = self
        userDetailViewController.modalPresentationStyle = .overCurrentContext
        present(userDetailViewController, animated: true, completion: nil)
    }

}

//extension HIScannerViewController: HIUserDetailViewControllerDelegate {
//    func willDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool) { }
//
//    func didDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool) {
//        respondingToQRCodeFound = true
//    }
//
//}

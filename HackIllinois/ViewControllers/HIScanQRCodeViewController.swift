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
        $0.activeImage = #imageLiteral(resourceName: "MenuClose")
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
    }
    private var selectedRows = Set<Int>()
    private var interests = Set<String>()
    private var statuses = Set<String>()
}

// MARK: - UIViewController
extension HIScanQRCodeViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        containerView.constrain(to: view, topInset: 0, bottomInset: 0)
        containerView.constrain(to: view, trailingInset: 0, leadingInset: 0)
        containerView.addSubview(previewView)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        closeButton.constrain(height: 40)
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
            let popupView = HIEventPopupViewController()
            popupView.modalPresentationStyle = .overCurrentContext
            popupView.modalTransitionStyle = .crossDissolve
            popupView.delegate = self
            popupView.selectedRows = selectedRows
            present(popupView, animated: true, completion: nil)
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
}

// MARK: - Actions
extension HIScanQRCodeViewController {
    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - HIGroupPopupViewDelegate
extension HIScanQRCodeViewController: HIEventPopupViewDelegate {
    func updateInterests(_ groupPopupCell: HIGroupPopupCell) {
        guard let indexPath = groupPopupCell.indexPath, let interest = groupPopupCell.interestLabel.text else { return }
        let modifiedInterest = interest.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "#", with: "%23").replacingOccurrences(of: "+", with: "%2b")
        if groupPopupCell.selectedImageView.isHidden {
            selectedRows.insert(indexPath.row)
            interests.insert(modifiedInterest)
        } else {
            selectedRows.remove(indexPath.row)
            interests.remove(modifiedInterest)
        }
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
        let code = meta?.stringValue
        let url = URL(string: code ?? "")
        respondingToQRCodeFound = false
        // Note: Need to figure out what to do with this QR Code data next.
    }
}

protocol HIEventPopupViewDelegate: class {
    func updateInterests(_ groupPopupCell: HIGroupPopupCell)
}

class HIEventPopupViewController: UIViewController {
    // MARK: Properties
    weak var delegate: HIEventPopupViewDelegate?

    let interests = HIInterestDataSource.shared.interestOptions
    let popupTableView = HITableView()
    var selectedRows: Set<Int>?
    var events: [Event] = []
    var names: [String] = []
    var selectedEvent: Event?

    private let containerView = HIView {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.buttonViewBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentHorizontalAlignment = .left
        $0.tintHIColor = \.titleText
        $0.titleHIColor = \.titleText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "CloseButton")
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
}

// MARK: Actions
extension HIEventPopupViewController {
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
extension HIEventPopupViewController {
    override func viewDidLoad() {
        HICoreDataController.shared.performBackgroundTask { context -> Void in
            do {
                let eventFetchRequest = NSFetchRequest<Event>(entityName: "Event")
                self.events = try context.fetch(eventFetchRequest)
                self.names = self.events.map { $0.name }
            }
            catch {}
        }
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        popupTableView.reloadData()
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        let selectSortLabel = HILabel(style: .sortText)
        selectSortLabel.text = "Select Event"

        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true

        containerView.addSubview(exitButton)
        exitButton.constrain(to: containerView, topInset: 8, leadingInset: 8)

        containerView.addSubview(selectSortLabel)
        selectSortLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10).isActive = true
        selectSortLabel.leadingAnchor.constraint(equalTo: exitButton.leadingAnchor, constant: 8).isActive = true
        selectSortLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        containerView.addSubview(popupTableView)
        popupTableView.topAnchor.constraint(equalTo: selectSortLabel.bottomAnchor, constant: 20).isActive = true
        popupTableView.leadingAnchor.constraint(equalTo: selectSortLabel.leadingAnchor).isActive = true
        popupTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35).isActive = true
        popupTableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

    }
}

// MARK: - UIGestureRecognizerDelegate
extension HIEventPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

// MARK: - UITableView Setup
extension HIEventPopupViewController {
    func setupTableView() {
        popupTableView.alwaysBounceVertical = false
        popupTableView.register(HIGroupPopupCell.self, forCellReuseIdentifier: HIGroupPopupCell.identifier)
        popupTableView.dataSource = self
        popupTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension HIEventPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGroupPopupCell.identifier, for: indexPath)
        if let cell = cell as? HIGroupPopupCell {
            cell.selectionStyle = .none
            cell.selectedImageView.isHidden = true
            cell.interestLabel.text = names[indexPath.row]
            cell.indexPath = indexPath
        }
        return cell
    }

}

// MARK: - UITableViewDelegate
extension HIEventPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = events[indexPath.row]
        dismiss(animated: true)
        tableView.reloadData()
    }
}

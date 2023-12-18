//
//  HIQRScannerSelection.swift
//  HackIllinois
//
//  Created by HackIllinois on 9/23/23.
//  Copyright © 2023 HackIllinois. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import HIAPI

class HIQRScannerSelection: HIBaseViewController {
    private let backgroundHIColor: HIColor = \.clear
    private let containerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.baseBackground
    }
    private let errorView = HIErrorView(style: .codePopup)
    private let closeButton = HIButton {
        $0.tintHIColor = \.action
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "DarkCloseButton")
        $0.baseImage = #imageLiteral(resourceName: "DarkCloseButton")
    }
    private let previewView = HIView {
        $0.backgroundHIColor = \.baseBackground
    }
    private let label = HILabel {
        $0.textHIColor = \.whiteText
        $0.backgroundHIColor = \.clear
        $0.textAlignment = .center
        $0.font = HIAppearance.Font.glyph
    }
    private let meetingButton = HIButton {
        $0.tintHIColor = \.action
        $0.backgroundHIColor = \.white
        $0.layer.borderWidth = 3.0
        $0.layer.borderColor = #colorLiteral(red: 0.7859038711, green: 0.9741206765, blue: 1, alpha: 1)
    }
    private let attendeeButton = HIButton {
        $0.tintHIColor = \.action
        $0.backgroundHIColor = \.buttonYellow
        $0.layer.borderWidth = 3.0
        $0.layer.borderColor = #colorLiteral(red: 1, green: 0.9568627451, blue: 0.5529411765, alpha: 1)
    }
    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "BackgroundNew")
    }
}

// MARK: - UIViewController
extension HIQRScannerSelection {
    override func loadView() {
        super.loadView()
        guard let user = HIApplicationStateController.shared.user else { return }
        if HIApplicationStateController.shared.isGuest && !user.roles.contains(.STAFF) { // Guest
            // Guest handler
            let background = #imageLiteral(resourceName: "ProfileBackground")
            let imageView: UIImageView = UIImageView(frame: view.bounds)
            view.addSubview(imageView)
            view.sendSubviewToBack(imageView)
            layoutErrorView()
        } else if !user.roles.contains(.STAFF) { // Attendee
            let scanQRCodePopup = HIScanQRCodeViewController()
            scanQRCodePopup.modalPresentationStyle = .overFullScreen
            scanQRCodePopup.modalTransitionStyle = .crossDissolve
            self.present(scanQRCodePopup, animated: true, completion: nil)
        } else if user.roles.contains(.STAFF) {
            view.addSubview(meetingButton)
            view.addSubview(attendeeButton)
            view.addSubview(closeButton)
            view.addSubview(label)
            // Add constraints for meetingButton and attendeeButton here
            meetingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
            meetingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            meetingButton.addTarget(self, action: #selector(didSelectMeetingButton(_:)), for: .touchUpInside)
            meetingButton.layer.cornerRadius = 15
            meetingButton.constrain(width: 290, height: 90)
            meetingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            attendeeButton.topAnchor.constraint(equalTo: meetingButton.bottomAnchor, constant: 30).isActive = true
            attendeeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            attendeeButton.addTarget(self, action: #selector(didSelectAttendeeButton(_:)), for: .touchUpInside)
            attendeeButton.layer.cornerRadius = 15
            attendeeButton.constrain(width: 290, height: 90)
            let meetingLabel = HILabel(style: .QRSelection)
            meetingLabel.text = "Meeting Attendance"
            meetingButton.addSubview(meetingLabel)
            meetingLabel.centerYAnchor.constraint(equalTo: meetingButton.centerYAnchor).isActive = true
            meetingLabel.centerXAnchor.constraint(equalTo: meetingButton.centerXAnchor).isActive = true
            let attendanceLabel = HILabel(style: .QRSelection)
            attendanceLabel.text = "Attendee Check In"
            attendeeButton.addSubview(attendanceLabel)
            attendanceLabel.centerYAnchor.constraint(equalTo: attendeeButton.centerYAnchor).isActive = true
            attendanceLabel.centerXAnchor.constraint(equalTo: attendeeButton.centerXAnchor).isActive = true
        }
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        closeButton.constrain(width: 60, height: 60)
        closeButton.imageView?.contentMode = .scaleToFill
        let label = HILabel(style: .viewTitleGreen)
        label.text = "ATTENDANCE"
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 3).isActive = true
    }
    override func viewDidLoad() {
        setCustomTitle(customTitle: "ATTENDANCE")
        super.viewDidLoad()
    }
    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        errorView.addSubview(closeButton)
    }
}

// MARK: - HIErrorViewDelegate
extension HIQRScannerSelection: HIErrorViewDelegate {
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

// MARK: - Actions
extension HIQRScannerSelection {
    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
        let scanQRCodePopup = HIQRScannerSelection()
        scanQRCodePopup.modalPresentationStyle = .overFullScreen
        scanQRCodePopup.modalTransitionStyle = .crossDissolve
        self.present(scanQRCodePopup, animated: true, completion: nil)
    }
}

extension HIQRScannerSelection {
    @objc func didSelectMeetingButton(_ sender: HIButton) {
        let scanQRCodePopup = HIScanAttendanceViewController()
        scanQRCodePopup.modalPresentationStyle = .overFullScreen
        scanQRCodePopup.modalTransitionStyle = .crossDissolve
        self.present(scanQRCodePopup, animated: true, completion: nil)
    }
}

extension HIQRScannerSelection {
    @objc func didSelectAttendeeButton(_ sender: HIButton) {
        let scanQRCodePopup = HIScanQRCodeViewController()
        scanQRCodePopup.modalPresentationStyle = .overFullScreen
        scanQRCodePopup.modalTransitionStyle = .crossDissolve
        self.present(scanQRCodePopup, animated: true, completion: nil)
    }
}

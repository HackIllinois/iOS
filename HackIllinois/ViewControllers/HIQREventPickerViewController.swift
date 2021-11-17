//
//  HIQREventPickerViewController.swift
//  HackIllinois
//
//  Created by Aryan Nambiar on 11/15/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import HIAPI

class HIQREventPickerViewController: HIBaseViewController {
    // MARK: Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.baseBackground
    }
    private var originalContainerFrameY: CGFloat = 0.0
    private var shiftedContainerFrameY: CGFloat = 0.0
    private var keyboardOpen: Bool = false
    private let errorView = HIErrorView(style: .codePopup)
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.baseText
        $0.titleHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
    private let submitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.interestBackground
        $0.titleHIColor = \.action
        $0.title = "Select Event"
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
        $0.textHIColor = \.baseText
        $0.backgroundHIColor = \.clear
    }
    private let bottomCodeFieldLine = CALayer()
    private let viewLabel = HILabel {
        $0.text = "Collect your points!"
        $0.font = HIAppearance.Font.detailTitle
        $0.textHIColor = \.baseText
        $0.backgroundHIColor = \.clear
    }
    private let popupImage = UIImage(named: "CodePopup")
    private let codeImage = HIImageView {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = UIImage()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
    }
    let dataArray = ["English", "Maths", "History", "German", "Science"]
}

// MARK: Actions
extension HIQREventPickerViewController {
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
        view.endEditing(true)
        keyboardOpen = false
        unregisterForKeyboardNotifications()
        if let code = codeField.text {
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
                        case "InvalidTime":
                            alertTitle = "Error!"
                            alertMessage = "Make sure you have the right time."
                        case "AlreadyCheckedIn":
                            alertTitle = "Error!"
                            alertMessage = "Looks like you're already checked in."
                        default:
                            alertTitle = "Error!"
                            alertMessage = "Something isn't quite right."
                        }
                        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                        if alertTitle == "Success!" {
                            alert.addAction(
                                UIAlertAction(title: "OK", style: .default, handler: { _ in
                                    self.dismiss(animated: true, completion: nil)
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

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: UIViewController
extension HIQREventPickerViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeField.text = ""
    }

    override func loadView() {
        super.loadView()

        let backgroundGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        backgroundGestureRecognizer.delegate = self
        view.addGestureRecognizer(backgroundGestureRecognizer)

        let containerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        containerView.addGestureRecognizer(containerGestureRecognizer)

        codeImage.image = popupImage
        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 284).isActive = true
        containerView.addSubview(exitButton)
        exitButton.constrain(to: containerView, topInset: 8, leadingInset: 8)
        if HIApplicationStateController.shared.isGuest {
            layoutErrorView()
        } else {
            layoutCodePopup()
        }
    }

    func layoutErrorView() {
        errorView.delegate = self
        containerView.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func layoutCodePopup() {
//        containerView.addSubview(codeImage)
//        codeImage.constrain(to: containerView, topInset: 15)
//        codeImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        codeImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
//        codeImage.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true
//        codeImage.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true
//
//        containerView.addSubview(viewLabel)
//        viewLabel.topAnchor.constraint(equalTo: codeImage.bottomAnchor, constant: 10).isActive = true
//        viewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//
//        codeField.autocorrectionType = .no
//        codeField.delegate = self
//        containerView.addSubview(codeField)
//        codeField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7).isActive = true
//        codeField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        containerView.addSubview(pickerView)
        pickerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pickerView.layer.borderWidth = 5
        pickerView.layer.borderColor = UIColor.blue.cgColor
        containerView.layer.borderWidth = 5
        containerView.layer.borderColor = UIColor.red.cgColor
//        containerView.addSubview(submitButton)
//        submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
//        submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        submitButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7).isActive = true
//        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.bringSubviewToFront(pickerView)
    }

    override func viewDidLayoutSubviews() {
        bottomCodeFieldLine.removeFromSuperlayer()
        bottomCodeFieldLine.frame = CGRect(x: 0.0, y: codeField.frame.height + 10, width: codeField.frame.width, height: 1.0)
        bottomCodeFieldLine.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.4470588235, alpha: 1)
        codeField.borderStyle = UITextField.BorderStyle.none
        codeField.layer.addSublayer(bottomCodeFieldLine)
        if keyboardOpen {
            containerView.frame.origin.y = shiftedContainerFrameY
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDatasource
extension HIQREventPickerViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = dataArray[row]
        return row
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return containerView.frame.height * 0.1 // you can calculate this based on your container view or window size
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("ROW \(row) SELECTED")
    }
}

// MARK: - UIGestureRecognizerDelegate
extension HIQREventPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

// MARK: - HIErrorViewDelegate
extension HIQREventPickerViewController: HIErrorViewDelegate {
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

extension HIQREventPickerViewController {
    override func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboardLayout(notification: notification) { (keyboardFrame) in
            if !self.keyboardOpen {
                self.originalContainerFrameY = self.containerView.frame.origin.y
                self.containerView.frame.origin.y = keyboardFrame.minY - self.containerView.frame.height - 10
                self.shiftedContainerFrameY = self.containerView.frame.origin.y
                self.keyboardOpen = true
            }
        }
    }

    override func keyboardWillHide(_ notification: NSNotification) {
        containerView.frame.origin.y = originalContainerFrameY
        keyboardOpen = false
    }
}

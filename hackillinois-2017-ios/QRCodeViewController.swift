//
//  QRCodeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 2/20/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit
import MIBlurPopup

class QRCodeViewController: UIViewController, MIBlurPopupDelegate {
    @IBOutlet weak var qrCode: UIImageView!
    
    var popupView: UIView {
        return qrCode
    }
    var blurEffectStyle = UIBlurEffectStyle.dark
    var initialScaleAmmount: CGFloat = 1
    var animationDuration: TimeInterval = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        qrCode.image = QRCodeGenerator.shared.qrcodeImage
        qrCode.layer.cornerRadius = 5
        qrCode.layer.masksToBounds = true
    }
    
    @IBAction func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

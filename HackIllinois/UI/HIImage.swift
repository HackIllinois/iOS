//
//  HIImage.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/28/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class QRCode {

    var image: UIImage

    // MARK: - Init
    init?(string: String, size: CGFloat) {
        let tint = CIColor(color: HIApplication.Palette.current.accent)
        let backgroundColor = CIColor(color: HIApplication.Palette.current.contentBackground)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator"),
            let colorFilter = CIFilter(name: "CIFalseColor"),
            let data = string.data(using: .utf8) else { return nil }

        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")

        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(tint, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")

        guard let ciImage = colorFilter.outputImage else { return nil }
        let scale = size / ciImage.extent.height
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledCIImage = ciImage.transformed(by: transform)
        image = UIImage(ciImage: scaledCIImage)
    }
}

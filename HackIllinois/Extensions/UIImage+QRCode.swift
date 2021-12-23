//
//  UIImage+QRCode.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/28/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit
import CoreGraphics

extension UIImage {
    convenience init?(qrString: String, size: CGFloat) {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator"),
            let colorFilter = CIFilter(name: "CIFalseColor"),
            let data = qrString.data(using: .utf8) else { return nil }

        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")

        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.black, forKey: "inputColor0")
        colorFilter.setValue(CIColor.clear, forKey: "inputColor1")

        guard let ciImage = colorFilter.outputImage else { return nil }
        let scale = size / ciImage.extent.height
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledCIImage = ciImage.transformed(by: transform)

        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(scaledCIImage, from: scaledCIImage.extent) else { return nil }

        self.init(cgImage: cgImage)
    }
    convenience init?(qrString: String, qrCodeColor: UIColor, backgroundImage: UIImage, logo: UIImage) {
        // Create simple QR Code
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator"),
              let data = qrString.data(using: .isoLatin1, allowLossyConversion: false)
            else { return nil }
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        // Bump up error correction
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        let firstScaleTransform = CGAffineTransform(scaleX: 9, y: 9)
        let initialScaledQRCode = qrFilter.outputImage?.transformed(by: firstScaleTransform)
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        maskToAlphaFilter.setDefaults()
        maskToAlphaFilter.setValue(initialScaledQRCode, forKey: kCIInputImageKey)
        // Add background to the center of the QR Code
        guard let simpleQRCode = maskToAlphaFilter.outputImage,
              let backgroundCGImage = backgroundImage.cgImage,
              let invertedQRCode = simpleQRCode.inverted,
              let tintedQRCode = invertedQRCode.tinted(using: qrCodeColor),
              let backgroundQRCode = tintedQRCode.combined(with: CIImage(cgImage: backgroundCGImage))
        else { return nil }
        let secondScaleTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        let scaledBackgroundQRCode = backgroundQRCode.transformed(by: secondScaleTransform)
        // Add logo on top of the round background
        guard let logoCGImage = logo.cgImage,
              let customQRCode = scaledBackgroundQRCode.combined(with: CIImage(cgImage: logoCGImage))
            else { return nil }
        self.init(ciImage: customQRCode)
    }
}

// https://gist.github.com/brownsoo/1b772612b54c4dc58d88ae71aec19552
public extension UIImage {
  func round(_ radius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { _ in
            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            rounded.addClip()
            if let cgImage = self.cgImage {
                UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation).draw(in: rect)
            }
        }
        return result
    }
}

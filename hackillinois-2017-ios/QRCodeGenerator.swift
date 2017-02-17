//
//  QRCodeGenerator.swift
//  hackillinois-2017-ios
//
//  Created by Kevin Rajan on 2/17/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class QRCodeGenerator {
    static let shared = QRCodeGenerator()
    
    private init() {
        
    }
    
    var id: NSNumber? {
        didSet {
            qrcodeImage = generateQRCode()
        }
    }
    private(set) var qrcodeImage: UIImage?
    
    func generateQRCode() -> UIImage {
        let data = NSData(bytes: &id, length: MemoryLayout<NSNumber>.size)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
}

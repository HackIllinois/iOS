//
//  QRCodeGenerator.swift
//  hackillinois-2017-ios
//
//  Created by Kevin Rajan on 2/17/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import UIKit

class QRCodeGenerator {
    static let shared = QRCodeGenerator()
    
    private init() { }
    
    var id: NSNumber? {
        didSet {
            qrcodeImage = UIImage.mdQRCode(for: "\(id ?? 0)", size: 600, fill: UIColor.hiaSeafoamBlue)
        }
    }
    private(set) var qrcodeImage: UIImage?
}

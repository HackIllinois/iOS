//
//  CacheController.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import UIKit
import PassKit

class CacheController {
    static let shared = CacheController()
    let pkPassCache = NSCache<NSString, PKPass>()
    let qrCodeCache = NSCache<NSString, UIImage>()
    
    func getPKPassKey(uniquePassString: String) -> String {
         return ("PKPASS_" + uniquePassString)
    }
    
    func getQRCodeKey(uniquePassString: String) -> String {
        return ("QRCODE_\(HIApplication.Theme.current)_\(uniquePassString)")
    }
    
}


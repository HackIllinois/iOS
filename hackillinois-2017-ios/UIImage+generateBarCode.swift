//
//  UIImage+generateBarCode.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

extension UIImage {
    /*
    class func imageFromText(string: String) -> UIImage {
        let font = UIFont.systemFontOfSize(12)
        
    }
    */
    
    class func generateBarCode(_ string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        // Image could not be created
        return nil
    }
}

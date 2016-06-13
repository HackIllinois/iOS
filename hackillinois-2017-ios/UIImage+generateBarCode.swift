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
    
    class func generateRotatedBarCode(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(3, 3)
            let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform).imageByApplyingTransform(rotate) {
                return UIImage(CIImage: output)
            }
        }
        
        // Image could not be created
        return nil
    }
}
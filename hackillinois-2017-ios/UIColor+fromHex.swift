//
//  UIColor+fromHex.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

//extension UIColor {
//    /*
//     * Converts a hexidecimal Int to a UIColor. If the alpha component is included, see fromRGBAHex(number: Int) instead.
//     */
//    
//    class func fromRGBHex(_ number: Int) -> UIColor {
//        let r = CGFloat(number >> 16) / 255
//        let g = CGFloat((number >> 8) & 0xFF) / 255
//        let b = CGFloat(number & 0xFF) / 255
//        
//        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
//    }
//    
//    /*
//     * Converts a hexidecimal Int to a UIColor. If the alpha component is not included, see fromRGBHex(number: Int) instead.
//     */
//    class func fromRGBAHex(_ number: Int) -> UIColor {
//        let r = CGFloat(number >> 24) / 255
//        let g = CGFloat((number >> 16) & 0xFF) / 255
//        let b = CGFloat((number >> 8) & 0xFF) / 255
//        let a = CGFloat(number & 0xFF) / 255
//     
//        return UIColor.init(red: r, green: g, blue: b, alpha: a)
//    }
//}

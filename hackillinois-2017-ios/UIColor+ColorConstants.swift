//
//  UIColor+ColorConstants.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 1/21/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import UIKit
// Color palette

extension UIColor {
    class var hiaDarkBlueGrey: UIColor {
        return UIColor(red: 20.0 / 255.0, green: 36.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaDarkSlateBlue: UIColor {
        return UIColor(red: 28.0 / 255.0, green: 50.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaDarkSlateBlueTwo: UIColor {
        return UIColor(red: 45.0 / 255.0, green: 70.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaDuskyBlue: UIColor {
        return UIColor(red: 78.0 / 255.0, green: 96.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaFadedBlue: UIColor {
        return UIColor(red: 128.0 / 255.0, green: 143.0 / 255.0, blue: 196.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaCloudyBlue: UIColor {
        return UIColor(red: 183.0 / 255.0, green: 190.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaPaleGrey: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 250.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaDarkGreenBlue: UIColor {
        return UIColor(red: 38.0 / 255.0, green: 103.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaSea: UIColor {
        return UIColor(red: 64.0 / 255.0, green: 155.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaSeafoamBlue: UIColor {
        return UIColor(red: 93.0 / 255.0, green: 200.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaDullOrange: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 161.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaMaize: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 184.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaLightMustard: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 200.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaBrick: UIColor {
        return UIColor(red: 177.0 / 255.0, green: 72.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaPaleRed: UIColor {
        return UIColor(red: 223.0 / 255.0, green: 89.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaFadedOrange: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 132.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaBerry: UIColor {
        return UIColor(red: 133.0 / 255.0, green: 26.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaLipstick: UIColor {
        return UIColor(red: 184.0 / 255.0, green: 34.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    class var hiaLipstickTwo: UIColor {
        return UIColor(red: 234.0 / 255.0, green: 51.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }
}

// Sample text styles

extension UIFont {
    class func hiaHeaderFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
    }
}

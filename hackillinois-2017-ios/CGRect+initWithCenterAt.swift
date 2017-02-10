//
//  CGRect+initWithCenterAt.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/5/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    /*
     * Creates a CGRect where the rectangle is centered at the specified x and y instead of having it be the origin
     */
    static func initWithCenterAt(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x - width / 2, y: y - height / 2, width: width, height: height)
    }
}

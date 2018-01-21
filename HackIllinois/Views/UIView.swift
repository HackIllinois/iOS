//
//  UIView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func renderAsImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

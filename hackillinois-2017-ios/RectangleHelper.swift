//
//  Rectangle_Helper.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/28/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import UIKit

func drawBorderRectangle(size: CGSize) -> UIImage {
    let opaque = false;
    let scale: CGFloat = 0;
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext();
    
    context!.setStrokeColor(UIColor.fromRGBHex(duskyBlueColor).cgColor)
    context!.setLineWidth(4.0)
    let borderRect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: size.width, height: size.height))
    let path = UIBezierPath(roundedRect: borderRect, byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width:5.0, height:5.0))
    path.close();
    path.stroke()
    
    
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!;
}
extension UIButton{
    func roundedButton(){
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft , .bottomRight],
                                    cornerRadii: CGSize.init(width: 5.0, height: 5.0));
        let maskLayer = CAShapeLayer();
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.cgPath;
        self.layer.mask = maskLayer;
        
    }
}


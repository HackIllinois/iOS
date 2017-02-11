//
//  InsetLabel.swift - Created for adding padding to UILabels, this can be used to achieve the affect seen on the profile view page
//  hackillinois-2017-ios
//
//  Created by Kevin Rajan on 2/10/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    let topInset = CGFloat(7.5)
    let bottomInset = CGFloat(7.5)
    let leftInset = CGFloat(14.5)
    let rightInset = CGFloat(14.5)
    
    override func drawText(in rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    

}

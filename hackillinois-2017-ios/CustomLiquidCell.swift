//
//  CustomLiquidCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/9/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SnapKit

/* Subclass UILabel to add padding */
class UILabelWithPadding: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

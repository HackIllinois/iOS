//
//  CustomLiquidCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/9/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import SnapKit

/* Subclass UILabel to add padding */
class UILabelWithPadding: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

class CustomLiquidCell : LiquidFloatingCell {
    var name: String!
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    internal override func setupView(_ view: UIView) {
        super.setupView(view)
        let label = UILabelWithPadding()
        label.text = name
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.alpha = 0.0 // Clear labels for smoother transition
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(-80)
            make.width.equalTo(65)
            make.top.height.equalTo(self)
        }
    }
}

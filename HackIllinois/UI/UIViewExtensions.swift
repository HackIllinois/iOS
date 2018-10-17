//
//  UIViewExtensions.swift
//  HackIllinois
//
//  Created by Alex Drewno on 10/15/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
    func setConstraints(superView: UIView, topInset: CGFloat? = nil, bottomInset: CGFloat? = nil, widthInset: CGFloat? = nil, heightInset: CGFloat? = nil, leadingInset: CGFloat? = nil, trailingInset: CGFloat? = nil) {
        
        if let topInset = topInset {
            topAnchor.constraint(equalTo: superView.topAnchor, constant: topInset).isActive = true
        }
        
        if let bottomInset = bottomInset {
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottomInset).isActive = true
        }
        
        if let widthInset = widthInset {
            widthAnchor.constraint(equalTo: superView.widthAnchor, constant: widthInset).isActive = true
        }
        
        if let heightInset = heightInset {
            heightAnchor.constraint(equalTo: superView.heightAnchor, constant: heightInset).isActive = true
        }
        
        if let leadingInset = leadingInset {
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingInset).isActive = true
        }
        
        if let trailingInset = trailingInset {
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailingInset).isActive = true
        }
        
    }
    
    func setConstraints(withLayoutGuide:UILayoutGuide, topInset: CGFloat? = nil, bottomInset: CGFloat? = nil, widthInset: CGFloat? = nil, heightInset: CGFloat? = nil, leadingInset: CGFloat? = nil, trailingInset: CGFloat? = nil) {
        
        if let topInset = topInset {
            topAnchor.constraint(equalTo: withLayoutGuide.topAnchor, constant: topInset).isActive = true
        }
        
        if let bottomInset = bottomInset {
            bottomAnchor.constraint(equalTo: withLayoutGuide.bottomAnchor, constant: bottomInset).isActive = true
        }
        
        if let widthInset = widthInset {
            widthAnchor.constraint(equalTo: withLayoutGuide.widthAnchor, constant: widthInset).isActive = true
        }
        
        if let heightInset = heightInset {
            heightAnchor.constraint(equalTo: withLayoutGuide.heightAnchor, constant: heightInset).isActive = true
        }
        
        if let leadingInset = leadingInset {
            leadingAnchor.constraint(equalTo: withLayoutGuide.leadingAnchor, constant: leadingInset).isActive = true
        }
        
        if let trailingInset = trailingInset {
            trailingAnchor.constraint(equalTo: withLayoutGuide.trailingAnchor, constant: trailingInset).isActive = true
        }
        
    }
    
}

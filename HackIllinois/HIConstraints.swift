//
//  HIConstraints.swift
//  HackIllinois
//
//  Created by Alex Drewno on 9/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIConstraints {
    
    //top, bottom, width, height, leading, traling
    class func setConstraints(constraintedView : UIView, equalToView : UIView, setTop : Bool, setBottom : Bool, setWidth : Bool, setHeight : Bool, setLeading : Bool, setTrailing : Bool) {
        
        setConstraintsWithOffsetFromView(constraintedView: constraintedView, equalToView: equalToView, setTop: setTop, setBottom: setBottom, setWidth: setWidth, setHeight: setHeight, setLeading: setLeading, setTrailing: setTrailing, topConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0, leadingConstant: 0, trailingConstant: 0)
        
    }
    
    class func setConstraintsWithOffsetFromView(constraintedView : UIView, equalToView : UIView, setTop : Bool, setBottom : Bool, setWidth : Bool, setHeight : Bool, setLeading : Bool, setTrailing : Bool, topConstant : CGFloat, bottomConstant : CGFloat, widthConstant : CGFloat, heightConstant : CGFloat, leadingConstant : CGFloat, trailingConstant : CGFloat) {
        
        if (setTop) {
            constraintedView.topAnchor.constraint(equalTo: equalToView.topAnchor, constant: topConstant).isActive = true
        }
        
        if (setBottom) {
            constraintedView.bottomAnchor.constraint(equalTo: equalToView.bottomAnchor, constant: bottomConstant).isActive = true
        }
        
        if (setWidth) {
            constraintedView.widthAnchor.constraint(equalTo: equalToView.widthAnchor, constant: widthConstant).isActive = true
        }
        
        if (setHeight) {
            constraintedView.heightAnchor.constraint(equalTo: equalToView.heightAnchor, constant: heightConstant).isActive = true
        }
        
        if (setLeading) {
            constraintedView.leadingAnchor.constraint(equalTo: equalToView.leadingAnchor, constant: leadingConstant).isActive = true
        }
        
        if (setTrailing) {
            constraintedView.trailingAnchor.constraint(equalTo: equalToView.trailingAnchor, constant: trailingConstant).isActive = true
        }
        
    }
    
    class func setConstraintConstants(constraintedView : UIView, setTop : Bool, setBottom : Bool, setWidth : Bool, setHeight : Bool, setLeading : Bool, setTrailing : Bool, topConstant : CGFloat, bottomConstant : CGFloat, widthConstant : CGFloat, heightConstant : CGFloat, leadingConstant : CGFloat, trailingConstant : CGFloat) {
        
        if (setTop) {
            constraintedView.topAnchor.constraint(constant: topConstant).isActive = true
        }
        
        if (setBottom) {
            constraintedView.bottomAnchor.constraint(constant: bottomConstant).isActive = true
        }
        
        if (setWidth) {
            constraintedView.widthAnchor.constraint(constant: widthConstant).isActive = true
        }
        
        if (setHeight) {
            constraintedView.heightAnchor.constraint(constant: heightConstant).isActive = true
        }
        
        if (setLeading) {
            constraintedView.leadingAnchor.constraint(constant: leadingConstant).isActive = true
        }
        
        if (setTrailing) {
            constraintedView.trailingAnchor.constraint(constant: trailingConstant).isActive = true
        }
        
    }
    
}


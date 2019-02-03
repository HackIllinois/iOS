//
//  Contents.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/7/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

import UIKit
import XCPlayground
import QuartzCore
import PlaygroundSupport

UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
let viewPath = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: 98, height: 98))
viewPath.lineWidth = 2
viewPath.stroke()
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

let view = UIView(frame:
    CGRect(
        x: 0,
        y: 0,
        width: 100,
        height: 100
    )
)
view.backgroundColor = UIColor.white
XCPShowView(identifier: "view", view: view)

let label = UILabel(frame: view.bounds)
label.text = "This is the text in the background behind the circle."
label.numberOfLines = 0
view.addSubview(label)

let effectView = UIVisualEffectView(effect:
    UIBlurEffect(style: .light))
effectView.frame = view.bounds
view.addSubview(effectView)
effectView.alpha = 0.8

let circleView = UIImageView(image: image)
effectView.contentView.addSubview(circleView)

let maskPath = UIBezierPath(ovalIn: circleView.bounds)
let mask = CAShapeLayer()
mask.path = maskPath.cgPath
effectView.layer.mask = mask
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

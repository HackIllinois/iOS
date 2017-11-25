//
//  HIRefreshControl.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class HIRefreshControl: UIView {


    override func awakeFromNib() {
        super.awakeFromNib()
        let refreshAnimation = LOTAnimationView(name: "loading")
        refreshAnimation.frame = bounds

        refreshAnimation.topAnchor.constraint(equalTo:    topAnchor)
        refreshAnimation.bottomAnchor.constraint(equalTo: bottomAnchor)
        refreshAnimation.leftAnchor.constraint(equalTo:   leftAnchor)
        refreshAnimation.rightAnchor.constraint(equalTo:  rightAnchor)

        refreshAnimation.loopAnimation = true
        refreshAnimation.contentMode = .center
        refreshAnimation.play()
        addSubview(refreshAnimation)
        layoutIfNeeded()
    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            subviews.forEach { (view) in
                view.frame = frame
            }
            super.frame = newValue
        }
    }


}

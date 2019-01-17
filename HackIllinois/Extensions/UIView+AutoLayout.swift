//
//  UIView+AutoLayout.swift
//  HackIllinois
//
//  Created by Alex Drewno on 10/15/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

internal extension UIView {
    func constrain(to view: UIView,
                   topInset: CGFloat? = nil,
                   trailingInset: CGFloat? = nil,
                   bottomInset: CGFloat? = nil,
                   leadingInset: CGFloat? = nil,
                   widthInset: CGFloat? = nil,
                   heightInset: CGFloat? = nil) {

        if let topInset = topInset {
            topAnchor.constraint(equalTo: view.topAnchor, constant: topInset).isActive = true
        }

        if let bottomInset = bottomInset {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomInset).isActive = true
        }

        if let widthInset = widthInset {
            widthAnchor.constraint(equalTo: view.widthAnchor, constant: widthInset).isActive = true
        }

        if let heightInset = heightInset {
            heightAnchor.constraint(equalTo: view.heightAnchor, constant: heightInset).isActive = true
        }

        if let leadingInset = leadingInset {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingInset).isActive = true
        }

        if let trailingInset = trailingInset {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingInset).isActive = true
        }
    }

    func constain(to layoutGuide: UILayoutGuide,
                  topInset: CGFloat? = nil,
                  trailingInset: CGFloat? = nil,
                  bottomInset: CGFloat? = nil,
                  leadingInset: CGFloat? = nil,
                  widthInset: CGFloat? = nil,
                  heightInset: CGFloat? = nil) {

        if let topInset = topInset {
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: topInset).isActive = true
        }

        if let bottomInset = bottomInset {
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: bottomInset).isActive = true
        }

        if let widthInset = widthInset {
            widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, constant: widthInset).isActive = true
        }

        if let heightInset = heightInset {
            heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, constant: heightInset).isActive = true
        }

        if let leadingInset = leadingInset {
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: leadingInset).isActive = true
        }

        if let trailingInset = trailingInset {
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: trailingInset).isActive = true
        }
    }
}

//
//  HIAppearance.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/4/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit

struct HIAppearance: Equatable {
    let primary: UIColor
    let accent: UIColor
    let background: UIColor
    let contentBackground: UIColor
    let actionBackground: UIColor
    let overlay: UIColor
    let frostedTint: UIColor
    let preferredStatusBarStyle: UIStatusBarStyle
    let indicatorStyle: UIScrollView.IndicatorStyle

    static let day = HIAppearance(
        primary: UIColor(named: "darkIndigo")!,
        accent: UIColor(named: "hotPink")!,
        background: UIColor(named: "paleBlue")!,
        contentBackground: UIColor(named: "white")!,
        actionBackground: UIColor(named: "lightPeriwinkle")!,
        overlay: UIColor(named: "darkBlueGrey")!,
        frostedTint: .clear,
        preferredStatusBarStyle: .default,
        indicatorStyle: .black
    )

    static let night = HIAppearance(
        primary: UIColor(red: 207/255, green: 216/255, blue: 238/255, alpha: 255/255),
        accent: UIColor(red: 244/255, green: 151/255, blue: 185/255, alpha: 255/255),
        background: UIColor(red: 17/255, green: 17/255, blue: 47/255, alpha: 255/255),
        contentBackground: UIColor(red: 34/255, green: 29/255, blue: 91/255, alpha: 255/255),
        actionBackground: UIColor(red: 64/255, green: 73/255, blue: 158/255, alpha: 255/255),
        overlay: UIColor.black,
        frostedTint: UIColor(red: 34/255, green: 29/255, blue: 91/255, alpha: 0.7),
        preferredStatusBarStyle: .lightContent,
        indicatorStyle: .white
    )

    static private(set) var current = day

    static func change(to newAppearance: HIAppearance) {
        guard current != newAppearance else { return }
        current = newAppearance

        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
}

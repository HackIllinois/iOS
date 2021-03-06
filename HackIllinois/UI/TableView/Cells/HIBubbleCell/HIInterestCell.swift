//
//  HIInterestCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/4/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

class HIInterestCell: UICollectionViewCell {
    // MARK: - Properties
    var interestLabel = HILabel(style: .profileInterests)
    var bubbleView = HIView {
        $0.backgroundHIColor = \.interestBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.3607843137, alpha: 0.3984650088)
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 1.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        bubbleView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        bubbleView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true

        bubbleView.addSubview(interestLabel)
        interestLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10).isActive = true
        interestLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10).isActive = true
        interestLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        interestLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

// MARK: - Population
extension HIInterestCell {
    static func <- (lhs: HIInterestCell, rhs: String) {
        lhs.interestLabel.text = rhs
    }
}

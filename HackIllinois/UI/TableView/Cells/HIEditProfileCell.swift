//
//  HIEditProfileCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/28/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIEditProfileCell: UITableViewCell {

    let attributeLabel = HILabel(style: .profileUsername)
    let infoLabel = HILabel(style: .profileDescription) { (label) in
        label.alpha = 0.5
        label.numberOfLines = 0
    }

    let separatorView = HIView(style: nil) { (view) in
        view.backgroundHIColor = \.whiteTagFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.alpha = 0.5
    }

    var separatorHalfWidthAnchor = NSLayoutConstraint()
    var separatorFullWidthAnchor = NSLayoutConstraint()

    var useHalfSeparator: Bool = true {
        didSet {
            separatorHalfWidthAnchor.isActive = false
            separatorFullWidthAnchor.isActive = false

            separatorHalfWidthAnchor.isActive = useHalfSeparator
            separatorFullWidthAnchor.isActive = !useHalfSeparator
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        contentView.layer.backgroundColor = UIColor.clear.cgColor

        contentView.addSubview(attributeLabel)
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        attributeLabel.constrain(to: self.contentView, topInset: 0, bottomInset: 0, leadingInset: 20)
        attributeLabel.constrain(width: 100)

        contentView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.constrain(to: self.contentView, topInset: 0, trailingInset: -20, bottomInset: 0)
        infoLabel.leadingAnchor.constraint(equalTo: attributeLabel.trailingAnchor, constant: 20).isActive = true

        contentView.addSubview(separatorView)
        separatorView.constrain(to: contentView, trailingInset: 0, bottomInset: 0)
        separatorHalfWidthAnchor = separatorView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor)
        separatorFullWidthAnchor = separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)

        if useHalfSeparator {
            separatorHalfWidthAnchor.isActive = true
            separatorFullWidthAnchor.isActive = false
        } else {
            separatorHalfWidthAnchor.isActive = false
            separatorFullWidthAnchor.isActive = true
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

}

// MARK: - Population
extension HIEditProfileCell {
    static func <- (lhs: HIEditProfileCell, rhs: (attribute: String, info: String)) {
        lhs.attributeLabel.text = rhs.attribute
        lhs.infoLabel.text = rhs.info
    }
}

//// MARK: - UITableViewCell
//extension HIEditProfileCell {
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        interestLabel.text = ""
//        selectedImageView.isHidden = false
//    }
//}

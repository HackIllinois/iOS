//
//  HIEditProfileDetailCell.swift
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

class HIEditProfileDetailCell: UITableViewCell {
    let itemTitle = HILabel(style: .profileUsername)
    let statusImageView = HIImageView { (imageView) in
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
    }

    var isActive = false {
        didSet {
            if isActive {
                statusImageView.image = #imageLiteral(resourceName: "SelectedProfileItem")
            } else {
                statusImageView.image = #imageLiteral(resourceName: "UnselectedProfileItem")
            }
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        contentView.layer.backgroundColor = UIColor.clear.cgColor

        contentView.addSubview(statusImageView)

        statusImageView.constrain(width: 30, height: 30)
        statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        statusImageView.constrain(to: contentView, trailingInset: -40)

        contentView.addSubview(itemTitle)
        itemTitle.constrain(to: contentView, topInset: 0, bottomInset: 0, leadingInset: 20)
        itemTitle.trailingAnchor.constraint(equalTo: statusImageView.leadingAnchor, constant: -20).isActive = true

        let separator = HIView { (view) in
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundHIColor = \.whiteTagFont
            view.alpha = 0.5
        }

        contentView.addSubview(separator)
        separator.constrain(to: contentView, bottomInset: 0)
        separator.leadingAnchor.constraint(equalTo: itemTitle.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HIEditProfileDetailCell {
    static func <- (lhs: HIEditProfileDetailCell, rhs: (itemTitle: String, isActive: Bool)) {
        lhs.itemTitle.text = rhs.itemTitle
        lhs.statusImageView.image = rhs.isActive ? #imageLiteral(resourceName: "SelectedProfileItem") : #imageLiteral(resourceName: "UnselectedProfileItem")
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

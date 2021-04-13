//
//  HIGroupPopupCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/27/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIGroupPopupCell: UITableViewCell {
    // MARK: - Properties
    var indexPath: IndexPath?
    let interestLabel = HILabel(style: .sortElement)

    let selectedImageView = HIImageView {
        $0.hiImage = \.checkmark
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentView.addSubview(interestLabel)
        interestLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        interestLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        interestLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        interestLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.75).isActive = true

        contentView.addSubview(selectedImageView)
        selectedImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        selectedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        selectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HIGroupPopupCell {
    static func <- (lhs: HIGroupPopupCell, rhs: HIInterest) {
        lhs.selectedImageView.isHidden = !rhs.selected
        lhs.interestLabel.text = rhs.name
    }
}

// MARK: - UITableViewCell
extension HIGroupPopupCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        interestLabel.text = ""
        selectedImageView.isHidden = false
    }
}

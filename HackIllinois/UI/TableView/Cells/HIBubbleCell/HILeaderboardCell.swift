//
//  HILeaderboardCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/03/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

class HILeaderboardCell: HIBubbleCell {
    // MARK: - Properties
    var profilePicture = HIImageView {
        $0.backgroundColor = UIColor.clear
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var innerVerticalStackView = UIStackView()
    var innerVerticalStackViewHeight = NSLayoutConstraint()
    var indexPath: IndexPath?
    //weak var delegate: HILeaderboardCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear

        // Add profile picture to bubble view
        profilePicture.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        bubbleView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 20).isActive = true
        profilePicture.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Add vertical stack
        bubbleView.addSubview(innerVerticalStackView)
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.distribution = .equalSpacing
        innerVerticalStackView.spacing = 5.0
        innerVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        innerVerticalStackView.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        innerVerticalStackView.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10).isActive = true
        innerVerticalStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        innerVerticalStackViewHeight = innerVerticalStackView.heightAnchor.constraint(equalToConstant: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}
// MARK: - Actions
extension HILeaderboardCell {
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

// MARK: - Population
extension HILeaderboardCell {

    // TODO: Make height of cell dynamic if needed
    static func heightForCell(with group: LeaderboardProfile, width: CGFloat) -> CGFloat {
        return 100
    }

    static func <- (lhs: HILeaderboardCell, rhs: LeaderboardProfile) {
        /*guard let profile = HIApplicationStateController.shared.profile else { return } */

        var innerVerticalStackViewHeight: CGFloat = 0

        let nameLabel = HILabel(style:  .groupNameInfo)
        nameLabel.text = ""
        innerVerticalStackViewHeight += nameLabel.intrinsicContentSize.height
        lhs.innerVerticalStackView.addArrangedSubview(nameLabel)
        lhs.innerVerticalStackViewHeight.constant = innerVerticalStackViewHeight
    }
}

// MARK: - UITableViewCell
extension HILeaderboardCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = UIImage()
        innerVerticalStackView.arrangedSubviews.forEach { (view) in
            innerVerticalStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

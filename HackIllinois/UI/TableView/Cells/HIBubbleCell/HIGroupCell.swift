//
//  HIGroupCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/19/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import HIAPI

class HIGroupCell: HIBubbleCell {
    // MARK: - Properties
    let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }
    var profilePicture = HIImageView {
        $0.backgroundColor = UIColor.clear
    }

    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var innerVerticalStackView = UIStackView()
    var innerVerticalStackViewHeight = NSLayoutConstraint()

    var spaceView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 12).isActive = true
        $0.backgroundHIColor = \.clear
    }
    var indexPath: IndexPath?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        bubbleView.addSubview(favoritedButton)
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0, bottomInset: 0)

        // add bubble view
        bubbleView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 20).isActive = true
        profilePicture.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 50).isActive = true

        bubbleView.addSubview(innerVerticalStackView)
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.distribution = .equalSpacing
        innerVerticalStackView.spacing = 5.0
        innerVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        innerVerticalStackView.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        innerVerticalStackView.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10).isActive = true
        innerVerticalStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        innerVerticalStackViewHeight = innerVerticalStackView.heightAnchor.constraint(equalToConstant: 0)

        bubbleView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 10.0
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 10).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)

        // Don't show favorite button for guests
        if HIApplicationStateController.shared.isGuest {
            favoritedButton.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Actions
extension HIGroupCell {
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

// MARK: - Population
extension HIGroupCell {

    static func heightForCell(with group: Profile) -> CGFloat {
        return 98 + 62
    }

    static func <- (lhs: HIGroupCell, rhs: Profile) {
        // lhs.favoritedButton.isActive = rhs.favorite
        var innerVerticalStackViewHeight: CGFloat = 0
        var contentStackViewHeight: CGFloat = 0

        if let url = URL(string: rhs.avatarUrl) {
            lhs.profilePicture.downloadImage(from: url)
        }

        let nameLabel = HILabel(style: .groupContactInfo)
        nameLabel.text = rhs.firstName + " " + rhs.lastName
        innerVerticalStackViewHeight += nameLabel.intrinsicContentSize.height
        lhs.innerVerticalStackView.addArrangedSubview(nameLabel)

        // Add conditional
        let statusLabel = HILabel(style: .lookingForGroup)
        statusLabel.text = rhs.teamStatus
        innerVerticalStackViewHeight += statusLabel.intrinsicContentSize.height + 3
        lhs.innerVerticalStackView.addArrangedSubview(statusLabel)

        let discordLabel = HILabel(style: .groupContactInfo)
        discordLabel.text = "Discord: \(rhs.discord)"
        contentStackViewHeight += discordLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(discordLabel)

        let description = HILabel(style: .groupDescription)
        description.text = rhs.info
        contentStackViewHeight += description.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(description)

        lhs.innerVerticalStackViewHeight.constant = innerVerticalStackViewHeight
        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }

}

// MARK: - UITableViewCell
extension HIGroupCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = UIImage()
        favoritedButton.isActive = false
        innerVerticalStackView.arrangedSubviews.forEach { (view) in
            innerVerticalStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

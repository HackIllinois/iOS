//
//  HIGroupCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/19/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

protocol HIGroupCellDelegate: class {
    func groupCellDidSelectFavoriteButton(_ groupCell: HIGroupCell)
}
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
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    weak var delegate: HIGroupCellDelegate?
    static let profileDict: [String: HIImage] = ["https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-0.png": \.profile0, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-1.png": \.profile1, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-2.png": \.profile2, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-3.png": \.profile3, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-4.png": \.profile4, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-5.png": \.profile5, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-6.png": \.profile6, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-7.png": \.profile7, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-8.png": \.profile8, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-9.png": \.profile9, "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-10.png": \.profile10]

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.constrain(width: 58, height: 60)
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)

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
        contentStackView.spacing = 27.0
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 12).isActive = true
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
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        delegate?.groupCellDidSelectFavoriteButton(self)
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

// MARK: - Population
extension HIGroupCell {

    static func heightForCell(with group: Profile, width: CGFloat) -> CGFloat {
        //BubbleView: 17
        // ContentLeft: 20
        //contentRight: 58
        
        let labelHeight = HILabel.heightForView(text: group.info, font: HIAppearance.Font.contentText, width: width - 102, numLines: 2)
        return 135 + labelHeight
    }

    static func <- (lhs: HIGroupCell, rhs: Profile) {
        lhs.favoritedButton.isActive = rhs.favorite
        var innerVerticalStackViewHeight: CGFloat = 0
        var contentStackViewHeight: CGFloat = 0

        if let url = URL(string: rhs.avatarUrl), let imgValue = profileDict[url.absoluteString] {
            lhs.profilePicture.changeImage(newImage: imgValue)
        }

        let nameLabel = HILabel(style: .groupNameInfo)
        nameLabel.text = rhs.firstName + " " + rhs.lastName
        innerVerticalStackViewHeight += nameLabel.intrinsicContentSize.height
        lhs.innerVerticalStackView.addArrangedSubview(nameLabel)

        let statusContainer = UIView()
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.backgroundColor = .clear

        let statusIndicator = HICircularView()
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.changeCircleColor(color: \.groupSearchText)
        statusContainer.addSubview(statusIndicator)
        statusIndicator.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 5).isActive = true
        statusIndicator.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor).isActive = true
        statusIndicator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        statusIndicator.widthAnchor.constraint(equalToConstant: 5).isActive = true

        let statusLabel = HILabel(style: .groupStatus)
        statusLabel.changeTextColor(color: \.groupSearchText)

        let modifiedTeamStatus = rhs.teamStatus.capitalized.replacingOccurrences(of: "_", with: " ")
        if modifiedTeamStatus == "Looking For Team" {
            statusIndicator.changeCircleColor(color: \.groupSearchText)
            statusLabel.changeTextColor(color: \.groupSearchText)
        } else if modifiedTeamStatus == "Looking For Members" {
            statusIndicator.changeCircleColor(color: \.memberSearchText)
            statusLabel.changeTextColor(color: \.memberSearchText)
        } else {
            statusIndicator.changeCircleColor(color: \.noSearchText)
            statusLabel.changeTextColor(color: \.noSearchText)
        }
        statusLabel.text = modifiedTeamStatus
        innerVerticalStackViewHeight += statusLabel.intrinsicContentSize.height + 3
        statusContainer.addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: statusContainer.topAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 5).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor).isActive = true
        lhs.innerVerticalStackView.addArrangedSubview(statusContainer)

        let discordContainer = UIView()
        discordContainer.translatesAutoresizingMaskIntoConstraints = false
        discordContainer.backgroundColor = .clear

        let discordImageView = HIImageView()
        discordImageView.contentMode = .scaleAspectFit
        discordImageView.image = #imageLiteral(resourceName: "DiscordLogo")
        discordContainer.addSubview(discordImageView)
        discordImageView.topAnchor.constraint(equalTo: discordContainer.topAnchor).isActive = true
        discordImageView.leadingAnchor.constraint(equalTo: discordContainer.leadingAnchor).isActive = true
        discordImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        discordImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let discordLabel = HILabel(style: .groupContactInfo)
        discordLabel.text = rhs.discord
        contentStackViewHeight += discordLabel.intrinsicContentSize.height + 3
        discordContainer.addSubview(discordLabel)
        discordLabel.topAnchor.constraint(equalTo: discordContainer.topAnchor).isActive = true
        discordLabel.centerYAnchor.constraint(equalTo: discordImageView.centerYAnchor).isActive = true
        discordLabel.leadingAnchor.constraint(equalTo: discordImageView.trailingAnchor, constant: 10).isActive = true
        discordLabel.trailingAnchor.constraint(equalTo: discordContainer.trailingAnchor).isActive = true
        lhs.contentStackView.addArrangedSubview(discordContainer)

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

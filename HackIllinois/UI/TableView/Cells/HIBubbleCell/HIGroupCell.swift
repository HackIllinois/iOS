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
        $0.image = #imageLiteral(resourceName: "ProfilePic")
    }
    
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()
    
    var innerHorizontalStackView = UIStackView()
    var innerHorizontalStackViewHeight = NSLayoutConstraint()
    
    var innerVerticalStackView = UIStackView()
    var innerVerticalStackViewHeight = NSLayoutConstraint()

    var spaceView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 12).isActive = true
        $0.backgroundHIColor = \.clear
    }
    var indexPath: IndexPath?
    //weak var delegate: HIGroupCellDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0, bottomInset: 0)
        
        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true

        innerHorizontalStackView.axis = .horizontal
        innerHorizontalStackView.distribution = .equalSpacing
        innerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addSubview(innerHorizontalStackView)
        innerHorizontalStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16).isActive = true
        innerHorizontalStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor).isActive = true
        innerHorizontalStackView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 16).isActive = true
        innerHorizontalStackViewHeight = innerHorizontalStackView.heightAnchor.constraint(equalToConstant: 0)
        innerHorizontalStackViewHeight.isActive = true
        
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.distribution = .equalSpacing
        innerVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        innerHorizontalStackView.addArrangedSubview(profilePicture)
        innerHorizontalStackView.addSubview(innerVerticalStackView)
        innerVerticalStackView.trailingAnchor.constraint(equalTo: innerHorizontalStackView.trailingAnchor).isActive = true
        innerVerticalStackView.topAnchor.constraint(equalTo: innerHorizontalStackView.topAnchor).isActive = true
        innerVerticalStackView.bottomAnchor.constraint(equalTo: innerHorizontalStackView.bottomAnchor).isActive = true
        innerVerticalStackViewHeight = innerVerticalStackView.heightAnchor.constraint(equalToConstant: 0)
        innerVerticalStackViewHeight.isActive = true
        
        
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
    // Change 'Project' once Group model is added
    static func heightForCell(with group: Project) -> CGFloat {
        return 98 + 31
    }
    // Calls to API should replace hard coded labels
    static func <- (lhs: HIGroupCell, rhs: Project) {
        lhs.favoritedButton.isActive = rhs.favorite
        var innerVerticalStackViewHeight: CGFloat = 0
        var contentStackViewHeight: CGFloat = 0
        
        let nameLabel = HILabel(style: .groupContactInfo)
        nameLabel.text = "Carter Smith"
        innerVerticalStackViewHeight += nameLabel.intrinsicContentSize.height
        lhs.innerVerticalStackView.addArrangedSubview(nameLabel)
        
        // Add conditional and profile pic when API is finished
        let statusLabel = HILabel(style: .lookingForGroup)
        statusLabel.text = "Looking for Team"
        innerVerticalStackViewHeight += statusLabel.intrinsicContentSize.height + 3
        lhs.innerVerticalStackView.addArrangedSubview(statusLabel)
        
        let discordLabel = HILabel(style: .groupContactInfo)
        discordLabel.text = "Discord: @HackThis"
        contentStackViewHeight += discordLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(discordLabel)
        
        let description = HILabel(style: .groupDescription)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        contentStackViewHeight += description.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(description)
    }
}

// MARK: - UITableViewCell
extension HIGroupCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritedButton.isActive = false
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

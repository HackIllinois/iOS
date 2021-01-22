//
//  HIGroupCell.swift
//  HackIllinois
//
//  Created by Carter Smith on 1/19/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import HIAPI

protocol HIGroupCellDelegate: class {
    func groupCellDidSelectFavoriteButton(_ groupCell:
        HIGroupCell)
}

class HIGroupCell: HIBubbleCell {
    // MARK: - Properties
    let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }
    
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var tagScrollView = UIScrollView()
    var tagStackView = UIStackView()
    var spaceView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 12).isActive = true
        $0.backgroundHIColor = \.clear
    }
    var indexPath: IndexPath?
    weak var delegate: HIGroupCellDelegate?
    
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

        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        tagStackView.axis = .horizontal
        tagStackView.alignment = .fill
        tagStackView.distribution = .equalSpacing
        tagStackView.spacing = 5.0
        tagScrollView.addSubview(tagStackView)

        tagStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagStackView.bottomAnchor.constraint(equalTo: tagScrollView.bottomAnchor).isActive = true
        tagStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        
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
        var contentStackViewHeight: CGFloat = 0
        let nameLabel = HILabel(style: .groupContactInfo)
        nameLabel.text = "Carter Smith"
        contentStackViewHeight += nameLabel.intrinsicContentSize.height
        lhs.contentStackView.addArrangedSubview(nameLabel)
        
        // Add conditional when API is finished
        let statusLabel = HILabel(style: .lookingForGroup)
        statusLabel.text = "Looking for Team"
        contentStackViewHeight += statusLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(statusLabel)
        
        let discordLabel = HILabel(style: .groupContactInfo)
        discordLabel.text = "Discord: @HackThis"
        contentStackViewHeight += discordLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(discordLabel)
        
        
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
        tagStackView.arrangedSubviews.forEach { (view) in
            tagStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

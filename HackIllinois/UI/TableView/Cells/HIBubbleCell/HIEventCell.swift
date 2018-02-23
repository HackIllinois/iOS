//
//  HIEventCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HIEventCellDelegate: class {
    func eventCellDidSelectFavoriteButton(_ eventCell: HIEventCell)
}

class HIEventCell: HIBubbleCell {
    // MARK: - Properties
    var favoritedButton = HIButton(style: .iconToggle(activeImage: #imageLiteral(resourceName: "Favorited"), inactiveImage: #imageLiteral(resourceName: "Unfavorited")))
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var indexPath: IndexPath?
    weak var delegate: HIEventCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        favoritedButton.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        favoritedButton.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true

        let disclosureIndicatorView = HIImageView(style: .icon(image: #imageLiteral(resourceName: "DisclosureIndicator")))
        bubbleView.addSubview(disclosureIndicatorView)
        disclosureIndicatorView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        disclosureIndicatorView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        disclosureIndicatorView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        disclosureIndicatorView.widthAnchor.constraint(equalToConstant: 65).isActive = true

        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: disclosureIndicatorView.leadingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Actions
extension HIEventCell {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        delegate?.eventCellDidSelectFavoriteButton(self)
    }
}

// MARK: - Population
extension HIEventCell {
    static func heightForCell(with event: Event) -> CGFloat {
        return 73 + 21 * CGFloat(event.locations.count)
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.setToggle(active: rhs.favorite)
        var contentStackViewHeight: CGFloat = 0
        let titleLabel = HILabel(style: .event)
        titleLabel.text = rhs.name
        contentStackViewHeight += titleLabel.intrinsicContentSize.height
        lhs.contentStackView.addArrangedSubview(titleLabel)
        if let locations = rhs.locations as? Set<Location> {
            for location in locations {
                let locationLabel = HILabel(style: .location)
                locationLabel.text = location.name
                contentStackViewHeight += locationLabel.intrinsicContentSize.height + 3
                lhs.contentStackView.addArrangedSubview(locationLabel)
            }
        }
        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }
}

// MARK: - UITableViewCell
extension HIEventCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritedButton.setToggle(active: false)
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

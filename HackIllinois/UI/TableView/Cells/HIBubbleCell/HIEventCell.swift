//
//  HIEventCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

protocol HIEventCellDelegate: class {
    func eventCellDidSelectFavoriteButton(_ eventCell: HIEventCell)
}

class HIEventCell: HIBubbleCell {
    // MARK: - Properties
    let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }

    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var indexPath: IndexPath?
    weak var delegate: HIEventCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.constrain(width: 58, height: 60)
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)

        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentStackView.axis = .vertical
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true

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
extension HIEventCell {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        delegate?.eventCellDidSelectFavoriteButton(self)
    }

    @objc func didSelectJoinStream(_ sender: HIButton) {
        print("JOIN STREAMM")
    }
}

// MARK: - Population
extension HIEventCell {
    static func heightForCell(with event: Event, width: CGFloat) -> CGFloat {
        let height = 90 + 40 + HILabel.heightForView(text: event.info, font: HIAppearance.Font.eventDetails, width: width - 100)
        if !event.sponsor.isEmpty {
            return height + 21
        }
        return height
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0

        let titleLabel = HILabel(style: .event)
        titleLabel.text = rhs.name
        lhs.contentStackView.addArrangedSubview(titleLabel)

        let timeLabel = HILabel(style: .eventTime)
        timeLabel.text = Formatter.simpleTime.string(from: rhs.startTime) + " - " + Formatter.simpleTime.string(from: rhs.endTime)
        lhs.contentStackView.addArrangedSubview(timeLabel)
        lhs.contentStackView.setCustomSpacing(10, after: timeLabel)

        if !rhs.sponsor.isEmpty {
            let sponsorLabel = HILabel(style: .sponsor)
            sponsorLabel.text = "Sponsored by \(rhs.sponsor)"
            contentStackViewHeight += sponsorLabel.intrinsicContentSize.height
            lhs.contentStackView.addArrangedSubview(sponsorLabel)
        }

        let descriptionLabel = HILabel(style: .cellDescription)
        descriptionLabel.text = rhs.info
        let height = HILabel.heightForView(text: rhs.info, font: HIAppearance.Font.eventDetails, width: lhs.contentView.frame.width - 100)
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        lhs.contentStackView.setCustomSpacing(10, after: descriptionLabel)

        let bottomView = HIView()
        bottomView.constrain(height: 30)

        let joinButton = HIButton { (button) in
            button.title = "Join Stream!"
            button.titleHIColor = \.whiteText
            button.backgroundHIColor = \.buttonBlue
            button.titleLabel?.font = HIAppearance.Font.eventButtonText
            button.layer.cornerRadius = 15
        }
        joinButton.addTarget(lhs.self, action: #selector(didSelectJoinStream(_:)), for: .touchUpInside)

        let eventType = HILabel(style: .eventType)
        eventType.text = "Mini Events"

        bottomView.addSubview(joinButton)
        bottomView.addSubview(eventType)
        joinButton.constrain(to: bottomView, topInset: 0, bottomInset: 0, leadingInset: 0)
        eventType.constrain(to: bottomView, topInset: 0, trailingInset: 0, bottomInset: 0)
        joinButton.trailingAnchor.constraint(equalTo: eventType.leadingAnchor).isActive = true
        joinButton.widthAnchor.constraint(equalTo: eventType.widthAnchor, multiplier: 1.5).isActive = true

        lhs.contentStackView.addArrangedSubview(bottomView)

        contentStackViewHeight += titleLabel.intrinsicContentSize.height + timeLabel.intrinsicContentSize.height + 13 + height + 3 + 40
        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }
}

// MARK: - UITableViewCell
extension HIEventCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritedButton.isActive = false
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

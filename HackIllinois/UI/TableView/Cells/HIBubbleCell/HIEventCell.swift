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

protocol HIEventCellDelegate: AnyObject {
    func eventCellDidSelectFavoriteButton(_ eventCell: HIEventCell)
}

class HIEventCell: HIBubbleCell {
    // MARK: - Properties
    let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.eventBackground
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

}

// MARK: - Population
extension HIEventCell {
    static func heightForCell(with event: Event, width: CGFloat) -> CGFloat {
        let heightFromEventName = HILabel.heightForView(text: event.name, font: HIAppearance.Font.eventTitle, width: width - 98)
        let heightFromEventInfo = HILabel.heightForView(text: trimText(text: event.info, length: getMaxDescriptionTextLength()), font: HIAppearance.Font.eventDetails, width: width - 100)
        let height = heightFromEventName + heightFromEventInfo + 90 + 15
        if !event.sponsor.isEmpty {
            return height + 21
        }
        return height
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0

        let titleLabel = HILabel(style: .event)
        titleLabel.numberOfLines = 0
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
        let descriptionText = trimText(text: rhs.info, length: getMaxDescriptionTextLength())
        descriptionLabel.text = descriptionText
        let height = HILabel.heightForView(text: descriptionText, font: HIAppearance.Font.eventDetails, width: lhs.contentView.frame.width - 100)
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        lhs.contentStackView.setCustomSpacing(10, after: descriptionLabel)

        let bottomView = HIView()
        bottomView.constrain(height: 30)

        let pointsView = HIView { (view) in
            view.layer.cornerRadius = 15
            view.backgroundHIColor = \.buttonGreen
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let pointsLabel = HILabel(style: .pointsText)
        pointsView.addSubview(pointsLabel)
        pointsLabel.constrain(to: pointsView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        pointsLabel.text = "\(rhs.points) Points!"

        let eventTypeLabel = HILabel(style: .eventType)
        let eventType = HIEventType(type: rhs.eventType)
        eventTypeLabel.text = eventType.description
        eventTypeLabel.textHIColor = getTagColor(for: rhs.eventType)
        eventTypeLabel.refreshForThemeChange()

        bottomView.addSubview(pointsView)
        bottomView.addSubview(eventTypeLabel)
        pointsView.constrain(to: bottomView, topInset: 0, bottomInset: 0, leadingInset: 0)
        eventTypeLabel.constrain(to: bottomView, topInset: 0, trailingInset: 0, bottomInset: 0)
        pointsView.trailingAnchor.constraint(equalTo: eventTypeLabel.leadingAnchor, constant: -5).isActive = true
        pointsView.widthAnchor.constraint(equalTo: eventTypeLabel.widthAnchor, multiplier: 1.2).isActive = true

        lhs.contentStackView.addArrangedSubview(bottomView)
        let textHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle, width: lhs.contentView.frame.width - 98)
        contentStackViewHeight += textHeight
        contentStackViewHeight += timeLabel.intrinsicContentSize.height + 13 + height + 3 + 40
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

// MARK: - HIColors for event type
extension HIEventCell {
    static func getTagColor(for eventType: String) -> HIColor {
        switch eventType {
        case "WORKSHOP":
            return \.eventTypePurple
        case "MINIEVENT":
            return \.eventTypeGreen
        case "SPEAKER":
            return \.eventTypeRed
        case "QNA":
            return \.eventTypeOrange
        default:
            return \.eventTypePink
        }
    }
}

// MARK: - Used for trimming the event description
extension HIEventCell {
    // Returns the maximum number of characters allowed for the event description
    static func getMaxDescriptionTextLength() -> Int {
        return 150
    }

    static func trimText(text: String, length: Int) -> String {
        if text.count >= length {
            let index = text.index(text.startIndex, offsetBy: length)
            return String(text[..<index]) + "..."
        }
        return text
    }
}

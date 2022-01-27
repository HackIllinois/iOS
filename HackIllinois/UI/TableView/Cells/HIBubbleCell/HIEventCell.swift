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
        $0.tintHIColor = \.accent
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
        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentStackView.axis = .vertical
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true
        // add favorited button
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.constrain(width: 58, height: 60)
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)

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
        let heightFromEventInfo = HILabel.heightForView(text: trimText(text: event.info, length: HIConstants.MAX_EVENT_DESCRIPTION_LENGTH), font: HIAppearance.Font.eventDetails, width: width - 100)
        let height = heightFromEventName + heightFromEventInfo + 90 + 15
        return height
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0
        // Add event title
        let titleLabel = HILabel(style: .event)
        titleLabel.numberOfLines = 0
        titleLabel.text = rhs.name
        lhs.contentStackView.addArrangedSubview(titleLabel)
        let titleHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle, width: lhs.contentView.frame.width - 98)
        contentStackViewHeight += titleHeight
        // Add event type
        let eventTypeLabel = HILabel(style: .eventType)
        eventTypeLabel.text = rhs.eventType.lowercased().capitalized
        contentStackViewHeight += eventTypeLabel.intrinsicContentSize.height
        lhs.contentStackView.addArrangedSubview(eventTypeLabel)
        // Create the container for showing time and points
        let timePointsContainer = HIView()
        timePointsContainer.constrain(height: 30)
        let timeImageView = UIImageView(image: #imageLiteral(resourceName: "Clock"))
        let timeLabel = HILabel(style: .eventTime)
        timeLabel.text = Formatter.simpleTime.string(from: rhs.startTime) + " - " + Formatter.simpleTime.string(from: rhs.endTime)
        timePointsContainer.addSubview(timeImageView)
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.topAnchor.constraint(equalTo: timePointsContainer.topAnchor, constant: 10).isActive = true
        timeImageView.leadingAnchor.constraint(equalTo: timePointsContainer.leadingAnchor).isActive = true

        timePointsContainer.addSubview(timeLabel)
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.leadingAnchor, constant: 20).isActive = true
        let pointsView = HIView { (view) in
            view.layer.cornerRadius = 8
            view.backgroundHIColor = \.buttonGreen
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let pointsLabel = HILabel(style: .pointsText)
        pointsLabel.text = " + \(rhs.points) pts  "
        timePointsContainer.addSubview(pointsView)
        pointsView.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        pointsView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10).isActive = true
        pointsView.addSubview(pointsLabel)
        pointsLabel.constrain(to: pointsView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        lhs.contentStackView.addArrangedSubview(timePointsContainer)
        lhs.contentStackView.setCustomSpacing(10, after: timePointsContainer)
        // Add description
        let descriptionLabel = HILabel(style: .detailText)
        let noWhiteSpaceDescription = rhs.info.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionText = trimText(text: noWhiteSpaceDescription, length: HIConstants.MAX_EVENT_DESCRIPTION_LENGTH)
        descriptionLabel.text = descriptionText
        let descriptionHeight = HILabel.heightForView(text: descriptionText, font: HIAppearance.Font.detailText, width: lhs.contentView.frame.width - 100)
        contentStackViewHeight += descriptionHeight
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        // Add extra height in order to keep even spacing between labels
        contentStackViewHeight += 46
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

// MARK: - Used for trimming the event description
extension HIEventCell {
    static func trimText(text: String, length: Int) -> String {
        if text.count >= length {
            let index = text.index(text.startIndex, offsetBy: length)
            return String(text[..<index]) + "..."
        }
        return text
    }
}

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
        $0.backgroundHIColor = \.favoriteStarTint
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }
    
    var headerView = UIStackView()
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var indexPath: IndexPath?
    weak var delegate: HIEventCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
//        bubbleView.addSubview(favoritedButton)
//        favoritedButton.constrain(width: 58, height: 60)
//        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)

        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        headerView.axis = .vertical
        headerView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(headerView)
        headerView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 17).isActive = true
        headerView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16).isActive = true
//        headerView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor).isActive = true
        
        
        bubbleView.addSubview(favoritedButton)
        favoritedButton.constrain(width: 58, height: 60)
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)
        favoritedButton.leadingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
//        favoritedButton.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor).isActive = true
        
        contentStackView.axis = .vertical
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        
        contentStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16).isActive = true
//        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        contentStackView.topAnchor.constraint(greaterThanOrEqualTo: favoritedButton.bottomAnchor, constant: 4).isActive = true
        contentStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4).isActive = true
        contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bubbleView.bottomAnchor).isActive = true
//        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
//        contentStackViewHeight.isActive = true
        
        

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
        let heightFromEventName = HILabel.heightForView(text: event.name, font: HIAppearance.Font.eventTitle, width: width - 137)
        let heightFromEventInfo = HILabel.heightForView(text: trimText(text: event.info, length: getMaxDescriptionTextLength()), font: HIAppearance.Font.eventDetails, width: width - 100)
        let height = heightFromEventName + heightFromEventInfo + 90 + 15
        if !event.sponsor.isEmpty {
            return height + 20
        }
        return height
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0

        let titleLabel = HILabel(style: .event)
        titleLabel.numberOfLines = 0
        titleLabel.text = rhs.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lhs.headerView.addArrangedSubview(titleLabel)
        lhs.headerView.setCustomSpacing(4, after: titleLabel)
//        titleLabel.constrain(to: lhs.headerView, topInset: 0, trailingInset: 0, leadingInset: 0)
        
        let eventTypeLabel = HILabel(style: .cellDescription)
        let eventType = HIEventType(type: rhs.eventType)
        eventTypeLabel.text = eventType.description
        eventTypeLabel.textHIColor = getTagColor(for: rhs.eventType)
        eventTypeLabel.refreshForThemeChange()
        eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        lhs.headerView.addArrangedSubview(eventTypeLabel)
//        eventTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
//        eventTypeLabel.constrain(to: lhs.headerView, trailingInset: 0, bottomInset: 0, leadingInset: 0)
//        eventTypeLabel.constrain(height: 20)
        
        let titleHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle, width: lhs.contentView.frame.width - 137) // Can test for a more accurate constant
        titleLabel.constrain(height: titleHeight)
        lhs.headerView.constrain(height: titleHeight + 20)
        
        if !rhs.sponsor.isEmpty {
            let sponsorLabel = HILabel(style: .cellDescription)
            sponsorLabel.text = "Sponsored by \(rhs.sponsor)"
            contentStackViewHeight += sponsorLabel.intrinsicContentSize.height
            sponsorLabel.constrain(height: 20)
            lhs.contentStackView.addArrangedSubview(sponsorLabel)
            lhs.contentStackView.setCustomSpacing(10, after: sponsorLabel)
        }
        
        let upperContainerView = HIView {
            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.backgroundHIColor = \.clear
        }
        lhs.contentStackView.addArrangedSubview(upperContainerView)
        
//        upperContainerView.constrain(height: 20)
        let timeImageView = UIImageView(image: #imageLiteral(resourceName: "Clock"))
        upperContainerView.addSubview(timeImageView)
        timeImageView.leadingAnchor.constraint(equalTo: upperContainerView.leadingAnchor).isActive = true
        timeImageView.centerYAnchor.constraint(equalTo: upperContainerView.centerYAnchor).isActive = true
//        timeImageView.constrain(width: 10, height: 10)
        

        let timeLabel = HILabel(style: .eventTime)
        timeLabel.text = Formatter.simpleTime.string(from: rhs.startTime) + " - " + Formatter.simpleTime.string(from: rhs.endTime)
        upperContainerView.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 5).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: upperContainerView.heightAnchor).isActive = true
//        lhs.headerView.addArrangedSubview(timeLabel)
//        lhs.headerView.setCustomSpacing(10, after: timeLabel)
        
        let pointsView = HIView { (view) in
            view.layer.cornerRadius = 15
            view.backgroundHIColor = \.buttonGreen
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let pointsLabel = HILabel(style: .pointsText)
        pointsView.addSubview(pointsLabel)
        pointsLabel.constrain(to: pointsView, topInset: 4, trailingInset: -8, bottomInset: -4, leadingInset: 8)
        pointsLabel.text = "+ \(rhs.points) pts"
        
        upperContainerView.addSubview(pointsView)
        pointsView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5).isActive = true
        pointsView.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
//        pointsView.heightAnchor.constraint(equalTo: upperContainerView.heightAnchor).isActive = true
        
        

        

        let descriptionLabel = HILabel(style: .cellDescription)
        let descriptionText = trimText(text: rhs.info, length: getMaxDescriptionTextLength())
        descriptionLabel.text = descriptionText
        let height = HILabel.heightForView(text: descriptionText, font: HIAppearance.Font.eventDetails, width: lhs.contentView.frame.width - 100)
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        lhs.contentStackView.setCustomSpacing(10, after: descriptionLabel)

//        let bottomView = HIView()
//        bottomView.constrain(height: 30)

        

        

//        bottomView.addSubview(pointsView)
//        bottomView.addSubview(eventTypeLabel)
//        pointsView.constrain(to: bottomView, topInset: 0, bottomInset: 0, leadingInset: 0)
//        eventTypeLabel.constrain(to: bottomView, topInset: 0, trailingInset: 0, bottomInset: 0)
//        pointsView.trailingAnchor.constraint(equalTo: eventTypeLabel.leadingAnchor, constant: -5).isActive = true
//        pointsView.widthAnchor.constraint(equalTo: eventTypeLabel.widthAnchor, multiplier: 1.2).isActive = true
//
//        lhs.contentStackView.addArrangedSubview(bottomView)
        let textHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle, width: lhs.contentView.frame.width - 98)
        contentStackViewHeight += textHeight
        contentStackViewHeight += timeLabel.intrinsicContentSize.height + 13 + height + 3 + 40
//        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }
}

// MARK: - UITableViewCell
extension HIEventCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritedButton.isActive = false
        headerView.subviews.forEach {(view) in
            headerView.willRemoveSubview(view)
            view.removeFromSuperview()
        }
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
        return 50
    }

    static func trimText(text: String, length: Int) -> String {
        let textNoLineBreaks = text.components(separatedBy: .newlines).joined()
        if textNoLineBreaks.count >= length {
            let index = textNoLineBreaks.index(textNoLineBreaks.startIndex, offsetBy: length)
            return String(textNoLineBreaks[..<index]) + "..."
        }
        return textNoLineBreaks
    }
}

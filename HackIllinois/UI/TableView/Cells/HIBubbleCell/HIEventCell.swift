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
    var headerView = UIStackView()
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    var indexPath: IndexPath?
    weak var delegate: HIEventCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var headerSpacingConstant: CGFloat = 1.0
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            headerSpacingConstant = 2.0
        }
        
        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        headerView.axis = .vertical
        headerView.alignment = .leading
        headerView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(headerView)
        headerView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 17 * headerSpacingConstant).isActive = true
        headerView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16 * headerSpacingConstant).isActive = true
        bubbleView.addSubview(favoritedButton)
        favoritedButton.constrain(width: 58 * headerSpacingConstant, height: 50 * headerSpacingConstant)
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0)

        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16).isActive = true
        contentStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4 * headerSpacingConstant).isActive = true
        contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bubbleView.bottomAnchor, constant: -16 * headerSpacingConstant).isActive = true
        // Don't show favorite button for guests
        if HIApplicationStateController.shared.isGuest {
            favoritedButton.isHidden = true // CHANGE BACK TO TRUE
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
        let heightFromEventName = HILabel.heightForView(text: event.name, font: HIAppearance.Font.eventTitle!, width: width - 137)
        //let heightFromHeader = (heightFromEventName + 4 + 17 < 60) ? 60 : heightFromEventName + 4 + 17
        var heightConstant: CGFloat = 1.3
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            heightConstant = 10.0
        }
        let height = heightFromEventName + 160
        if !event.sponsor.isEmpty {
            return height + (20 * heightConstant)
        }
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return height + (20 * (heightConstant / 1.3))
        }
        return height
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0.0
        var eventCellSpacing: CGFloat = 8.0
        var stackViewSpacing: CGFloat = 3.5
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            eventCellSpacing = 12.0
            stackViewSpacing = 12.0
        }

        let titleLabel = HILabel(style: .event)
        titleLabel.numberOfLines = 0
        titleLabel.text = rhs.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lhs.headerView.addArrangedSubview(titleLabel)
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            lhs.headerView.setCustomSpacing(18, after: titleLabel)
        } else {
            lhs.headerView.setCustomSpacing(9, after: titleLabel)
        }
        let eventTypeLabel = HILabel(style: .cellDescription)
        let eventType = HIEventType(type: rhs.eventType)
        eventTypeLabel.text = eventType.description.lowercased().capitalized
        eventTypeLabel.textHIColor = \.baseText
        eventTypeLabel.refreshForThemeChange()
        eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle!, width: lhs.contentView.frame.width - 137) // Can test for a more accurate constant
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            titleLabel.constrain(height: titleHeight + 20)
        } else {
            titleLabel.constrain(height: titleHeight)
/*
        lhs.headerView.addArrangedSubview(eventTypeLabel)
    
        eventTypeLabel.constrain(height: 20)
        if !rhs.sponsor.isEmpty {
            let sponsorLabel = HILabel(style: .cellDescription)
            sponsorLabel.text = "Sponsored by \(rhs.sponsor)"
            contentStackViewHeight += sponsorLabel.intrinsicContentSize.height
            sponsorLabel.constrain(height: 25)
            lhs.contentStackView.addArrangedSubview(sponsorLabel)
            lhs.contentStackView.setCustomSpacing(10, after: sponsorLabel)*/
        }
        let upperContainerView = HIView {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let middleContainerView = HIView {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let bottomContainerView = HIView {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let tempSpacer = HIView {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        lhs.contentStackView.addArrangedSubview(tempSpacer)
        tempSpacer.constrain(height: 6)
        lhs.contentStackView.addArrangedSubview(upperContainerView)
        lhs.contentStackView.addArrangedSubview(middleContainerView)
        lhs.contentStackView.addArrangedSubview(bottomContainerView)
        var timeImageView = UIImageView(image: #imageLiteral(resourceName: "Clock"))
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            timeImageView = UIImageView(image: #imageLiteral(resourceName: "TimePad"))
        }
        let timeLabel = HILabel(style: .newTime)
        // We can check for async events by checking if the event start and end time is 1970-01-01 00:00:00 +0000
        if rhs.startTime.timeIntervalSince1970 == 0 || rhs.endTime.timeIntervalSince1970 == 0 {
            // Default text for async events
            timeLabel.text = HIConstants.ASYNC_EVENT_TIME_TEXT
        } else {
            timeLabel.text = Formatter.simpleTime.string(from: rhs.startTime) + " - " + Formatter.simpleTime.string(from: rhs.endTime)
        }
        var bubbleConstant: CGFloat = 1.0
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            bubbleConstant = 2.0
        }
        let pointsView = HIView { (view) in
            view.layer.cornerRadius = 10.5 * bubbleConstant
            view.backgroundHIColor = \.buttonPink
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let eventTypeView = HIView { (view) in
            view.layer.cornerRadius = 10.5 * bubbleConstant
            view.backgroundHIColor = \.buttonBlue
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let pointsLabel = HILabel(style: .pointsText)
        pointsView.addSubview(pointsLabel)
        pointsLabel.constrain(to: pointsView, topInset: 4, trailingInset: -8, bottomInset: -4, leadingInset: 8)
        pointsLabel.text = "+ \(rhs.points) pts"
        upperContainerView.addSubview(pointsView)
        
        let typeLabel = HILabel(style: .pointsText)
        eventTypeView.addSubview(typeLabel)
        typeLabel.constrain(to: eventTypeView, topInset: 4, trailingInset: -8, bottomInset: -4, leadingInset: 8)
        typeLabel.text = eventType.description.lowercased().capitalized
        eventTypeView.constrain(height: 20 * bubbleConstant)
        lhs.headerView.addArrangedSubview(eventTypeView)
        lhs.headerView.setCustomSpacing(eventCellSpacing, after: eventTypeView)
    
        pointsView.leadingAnchor.constraint(equalTo: eventTypeView.trailingAnchor, constant: 8 * bubbleConstant).isActive = true
        pointsView.centerYAnchor.constraint(equalTo: eventTypeView.centerYAnchor).isActive = true
        pointsView.constrain(height: 20 * bubbleConstant)
        
        upperContainerView.addSubview(timeImageView)
        upperContainerView.addSubview(timeLabel)
        
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: eventCellSpacing + 1).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        
        var sponsorImageView = UIImageView(image: #imageLiteral(resourceName: "Vector"))
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            sponsorImageView = UIImageView(image: #imageLiteral(resourceName: "SponsorPad"))
        }
        if !rhs.sponsor.isEmpty {
            let sponsorLabel = HILabel(style: .newSponsor)
            sponsorLabel.text = "\(rhs.sponsor)"
            contentStackViewHeight += sponsorLabel.intrinsicContentSize.height
            sponsorLabel.constrain(height: 18 * bubbleConstant)
            middleContainerView.addSubview(sponsorImageView)
            middleContainerView.addSubview(sponsorLabel)
            sponsorImageView.bottomAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: (stackViewSpacing * 2.5) + 14).isActive = true
            sponsorLabel.leadingAnchor.constraint(equalTo: sponsorImageView.trailingAnchor, constant: eventCellSpacing + 1).isActive = true
            sponsorLabel.centerYAnchor.constraint(equalTo: sponsorImageView.centerYAnchor).isActive = true
            lhs.contentStackView.setCustomSpacing(eventCellSpacing, after: sponsorImageView)
        }
        var locationImageView = UIImageView(image: #imageLiteral(resourceName: "LocationSign"))
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            locationImageView = UIImageView(image: #imageLiteral(resourceName: "VectorPad"))
        }
        let locationLabel = HILabel(style: .newLocation)
        for location in rhs.locations {
            guard let location = location as? Location else { continue }
            locationLabel.text = "\(location.name)"
            print("Success")
        }
        bottomContainerView.addSubview(locationImageView)
        bottomContainerView.addSubview(locationLabel)
        if !rhs.sponsor.isEmpty {
            locationImageView.centerYAnchor.constraint(equalTo: sponsorImageView.centerYAnchor, constant: (stackViewSpacing * 2.5) + 14).isActive = true
            locationImageView.leftAnchor.constraint(equalTo: sponsorImageView.leftAnchor, constant: 1.5 * bubbleConstant).isActive = true
        } else {
            locationImageView.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor, constant: (stackViewSpacing * 2.5) + 14).isActive = true
            locationImageView.leftAnchor.constraint(equalTo: timeImageView.leftAnchor, constant: 1.5 * bubbleConstant).isActive = true
        }
        locationLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor).isActive = true
        lhs.contentStackView.setCustomSpacing((stackViewSpacing * 2.5) + 14, after: locationImageView)
        
        let descriptionLabel = HILabel(style: .cellDescription)
        descriptionLabel.numberOfLines = 2
        let descriptionText = rhs.info
        descriptionLabel.text = descriptionText
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            descriptionLabel.trailingAnchor.constraint(equalTo: lhs.contentStackView.trailingAnchor, constant: -40).isActive = true
        }
        let textHeight = HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle!, width: lhs.contentView.frame.width - 98)
        lhs.contentStackView.setCustomSpacing(10, after: descriptionLabel)
        contentStackViewHeight += textHeight
        contentStackViewHeight += timeLabel.intrinsicContentSize.height + locationLabel.intrinsicContentSize.height + 13 + 40 + 3 + 40
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

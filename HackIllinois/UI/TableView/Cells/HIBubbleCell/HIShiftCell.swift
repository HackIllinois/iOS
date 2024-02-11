//
//  HIShiftCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/10/24.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI


class HIShiftCell: HIBubbleCell {
    // MARK: - Properties
    var headerView = UIStackView()
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()
    
    var indexPath: IndexPath?
    weak var delegate: HIEventCellDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var headerSpacingConstant: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            headerSpacingConstant = 2.0
        }
        backgroundColor = UIColor.clear
        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        bubbleView.addSubview(headerView)
        headerView.axis = .vertical
        headerView.alignment = .leading
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 17 * headerSpacingConstant).isActive = true
        headerView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16 * headerSpacingConstant).isActive = true
        
        bubbleView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16).isActive = true
        contentStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10 * headerSpacingConstant).isActive = true
        contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bubbleView.bottomAnchor, constant: -16 * headerSpacingConstant).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HIShiftCell {
    static func heightForCell(with event: Event, width: CGFloat) -> CGFloat {
        let heightFromEventName = HILabel.heightForView(text: event.name, font: HIAppearance.Font.eventTitle!, width: width - 137)
        var heightConstant: CGFloat = 1.6
        if UIDevice.current.userInterfaceIdiom == .pad {
            heightConstant = 11.0
        }
        let height = heightFromEventName + 160
        if UIDevice.current.userInterfaceIdiom == .pad {
            return height + (22 * (heightConstant / 1.45))
        }
        return height + 5
    }
    static func <- (lhs: HIShiftCell, rhs: Event) {
        print(rhs)
        var contentStackViewHeight: CGFloat = 0.0; var eventCellSpacing: CGFloat = 8.0
        var stackViewSpacing: CGFloat = 4.7; var bubbleConstant: CGFloat = 1.0
        var locationImageView = UIImageView(image: #imageLiteral(resourceName: "LocationSign")); var timeImageView = UIImageView(image: #imageLiteral(resourceName: "Clock"))
        let titleLabel = HILabel(style: .event)
        titleLabel.numberOfLines = 2; titleLabel.text = rhs.name
        lhs.headerView.addArrangedSubview(titleLabel)
        lhs.headerView.setCustomSpacing(9, after: titleLabel)
        if UIDevice.current.userInterfaceIdiom == .pad {
            eventCellSpacing = 12.0; stackViewSpacing = 15.0; bubbleConstant = 2.0
            locationImageView = UIImageView(image: #imageLiteral(resourceName: "VectorPad"))
            timeImageView = UIImageView(image: #imageLiteral(resourceName: "TimePad"))
            lhs.headerView.setCustomSpacing(18, after: titleLabel)
        }
        titleLabel.constrain(width: lhs.contentView.frame.width - 120, height: (HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle!, width: lhs.contentView.frame.width - 137)) * bubbleConstant)
        let upperContainerView = HIView {
            lhs.contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let middleContainerView = HIView {
            lhs.contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let timeLabel = HILabel(style: .time)
        // We can check for async events by checking if the event start and end time is 1970-01-01 00:00:00 +0000
        if rhs.startTime.timeIntervalSince1970 == 0 || rhs.endTime.timeIntervalSince1970 == 0 {
            timeLabel.text = HIConstants.ASYNC_EVENT_TIME_TEXT
        } else {
            timeLabel.text = Formatter.simpleTime.string(from: rhs.startTime) + " - " + Formatter.simpleTime.string(from: rhs.endTime)
        }
        upperContainerView.addSubview(timeImageView)
        upperContainerView.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: eventCellSpacing + 1).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        let locationLabel = HILabel(style: .newLocation)
        if rhs.locations.count > 0 {
            locationLabel.text = rhs.locations.map({ ($0 as AnyObject).name }).joined(separator: ", ")
        }
        middleContainerView.addSubview(locationImageView)
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        middleContainerView.addSubview(locationLabel)
        locationImageView.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor, constant: (stackViewSpacing * 2.5) + 14).isActive = true
        locationImageView.centerXAnchor.constraint(equalTo: timeImageView.centerXAnchor).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor).isActive = true
        let descriptionLabel = HILabel(style: .cellDescription)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = "\(rhs.info)"
        lhs.contentStackView.addArrangedSubview(descriptionLabel)
        contentStackViewHeight += HILabel.heightForView(text: rhs.name, font: HIAppearance.Font.eventTitle!, width: lhs.contentView.frame.width - 98)
        contentStackViewHeight += timeLabel.intrinsicContentSize.height + locationLabel.intrinsicContentSize.height + 13 + 40 + 3 + 40
    }
}

// MARK: - UITableViewCell
extension HIShiftCell {
    override func prepareForReuse() {
        super.prepareForReuse()
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

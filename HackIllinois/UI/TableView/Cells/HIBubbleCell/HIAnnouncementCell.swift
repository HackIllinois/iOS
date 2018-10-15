//
//  HIAnnouncementCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIAnnouncementCell: HIBubbleCell {
    // MARK: - Properties
    var titleLabel = HILabel(style: .subtitle)
    var timeLabel = HILabel(style: .subtitle)
    var infoLabel = HILabel(style: .description)

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(bubbleView)
        
        bubbleView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 23).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        bubbleView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        bubbleView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 23).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -14).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HIAnnouncementCell {
    static func <- (lhs: HIAnnouncementCell, rhs: Announcement) {
        lhs.titleLabel.text = rhs.title
        lhs.timeLabel.text  = Date.humanReadableTimeSince(rhs.time)
        lhs.infoLabel.text  = rhs.info
    }
}

extension HIAnnouncementCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        timeLabel.text  = nil
        infoLabel.text  = nil
    }
}

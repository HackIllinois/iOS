//
//  HIAnnouncementCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIAnnouncementCell: HIBaseTableViewCell {
    // MARK: - Properties
    var titleLabel = HILabel(style: .subtitle)
    var timeLabel = HILabel(style: .subtitle)
    var infoLabel = HILabel(style: .description)

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        containerView.backgroundColor = HIApplication.Palette.current.contentBackground
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        containerView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        containerView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
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

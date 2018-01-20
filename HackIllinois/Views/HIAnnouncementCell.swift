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
    // MARK: - Static
    static let IDENTIFIER = "HIAnnouncementCell"

    static func <- (lhs: HIAnnouncementCell, rhs: Announcement) {
        lhs.titleLabel.text = rhs.title.capitalized
        lhs.timeLabel.text  = Date.humanReadableTimeSince(rhs.time)
        lhs.infoLabel.text  = rhs.info
    }

    // MARK: - Properties
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var infoLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = HIColor.paleBlue

        containerView.backgroundColor = HIColor.white
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        
        titleLabel.textColor = HIColor.hotPink
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true        


        timeLabel.textColor = HIColor.hotPink
        timeLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        
        infoLabel.textColor = HIColor.darkIndigo
        infoLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Static
extension HIAnnouncementCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        timeLabel.text  = nil
        infoLabel.text  = nil
    }
}

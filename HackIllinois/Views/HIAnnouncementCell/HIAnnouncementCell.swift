//
//  HIAnnouncementCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIAnnouncementCell: HITableViewCell {
    // MARK: - Static
    static let IDENTIFIER = "HIAnnouncementCell"

    static func <- (lhs: HIAnnouncementCell, rhs: Announcement) {
        lhs.titleLabel.text = rhs.title.capitalized
        lhs.timeLabel.text  = Date.humanReadableTimeSince(rhs.time)
        lhs.infoLabel.text  = rhs.info
    }

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
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

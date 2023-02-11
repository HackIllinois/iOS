//
//  HILeaderboardCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/03/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import MapKit

class HILeaderboardCell: UITableViewCell {
    var horizontalStackView = UIStackView()
    var indexPath: IndexPath?
    let nameLabel = HILabel(style: .leaderboardName)
    let rankLabel = HILabel(style: .leaderboardRank)
    let pointsLabel = HILabel(style: .leaderboardPoints)

    var cellView = HIView {
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = false
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.addSubview(cellView)
        cellView.constrain(to: safeAreaLayoutGuide, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        cellView.addSubview(rankLabel)
        cellView.addSubview(pointsLabel)
        cellView.addSubview(nameLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HILeaderboardCell {
    static func heightForCell(with group: LeaderboardProfile, width: CGFloat) -> CGFloat {
        return 60
    }

    static func <- (lhs: HILeaderboardCell, rhs: LeaderboardProfile) {
        var padConstant = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            padConstant = 2.0
        }
        lhs.rankLabel.textAlignment = .center
        lhs.pointsLabel.textAlignment = .center
        lhs.pointsLabel.backgroundHIColor = \.pointsBackground
        lhs.pointsLabel.layer.masksToBounds = true
        lhs.pointsLabel.layer.cornerRadius = lhs.contentView.frame.height * 0.45 / 2
        lhs.pointsLabel.text = " \(rhs.points) pts "
        lhs.pointsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let discord = rhs.discord ?? ""
        lhs.nameLabel.text = discord
        lhs.nameLabel.textAlignment = .left

        lhs.rankLabel.centerYAnchor.constraint(equalTo: lhs.cellView.centerYAnchor).isActive = true
        lhs.rankLabel.leadingAnchor.constraint(equalTo: lhs.cellView.leadingAnchor, constant: 25 * padConstant).isActive = true
        lhs.rankLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        lhs.pointsLabel.centerYAnchor.constraint(equalTo: lhs.cellView.centerYAnchor).isActive = true
        lhs.pointsLabel.widthAnchor.constraint(equalTo: lhs.cellView.widthAnchor, multiplier: 0.24).isActive = true
        lhs.pointsLabel.trailingAnchor.constraint(equalTo: lhs.cellView.trailingAnchor, constant: -25).isActive = true
        lhs.pointsLabel.heightAnchor.constraint(equalTo: lhs.cellView.heightAnchor, multiplier: 0.38).isActive = true

        lhs.nameLabel.centerYAnchor.constraint(equalTo: lhs.cellView.centerYAnchor).isActive = true
        lhs.nameLabel.leadingAnchor.constraint(equalTo: lhs.rankLabel.leadingAnchor, constant: 50 * padConstant).isActive = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        } else {
            lhs.nameLabel.constrain(width: lhs.contentView.frame.width - 185, height: (HILabel.heightForView(text: discord, font: HIAppearance.Font.leaderboardPoints!, width: lhs.contentView.frame.width - 185)))
            lhs.nameLabel.numberOfLines = 1
        }
    }
}

// MARK: - UITableViewCell
extension HILeaderboardCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalStackView.arrangedSubviews.forEach { (view) in
            horizontalStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

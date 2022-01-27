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
        $0.backgroundHIColor = \.contentBackground
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

        cellView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.spacing = 5.0
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
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
        lhs.pointsLabel.textAlignment = .center
        lhs.pointsLabel.backgroundHIColor = \.pointsBackground
        lhs.pointsLabel.layer.masksToBounds = true
        lhs.pointsLabel.layer.cornerRadius = lhs.contentView.frame.height * 0.45 / 2

        lhs.nameLabel.text = "\(rhs.firstName!) \(rhs.lastName!)"
        lhs.pointsLabel.text = "\(rhs.points) pts"
        lhs.rankLabel.text = "\((lhs.indexPath?.row ?? 100) + 1)"

        lhs.horizontalStackView.addArrangedSubview(lhs.rankLabel)
        lhs.rankLabel.centerYAnchor.constraint(equalTo: lhs.safeAreaLayoutGuide.centerYAnchor).isActive = true

        lhs.horizontalStackView.addArrangedSubview(lhs.nameLabel)
        lhs.nameLabel.centerYAnchor.constraint(equalTo: lhs.safeAreaLayoutGuide.centerYAnchor).isActive = true

        lhs.horizontalStackView.addArrangedSubview(lhs.pointsLabel)
        lhs.pointsLabel.heightAnchor.constraint(equalTo: lhs.contentView.heightAnchor, multiplier: 0.45).isActive = true
        lhs.pointsLabel.centerYAnchor.constraint(equalTo: lhs.safeAreaLayoutGuide.centerYAnchor).isActive = true
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

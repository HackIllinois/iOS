//
//  HIEventCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEventCell: HIBaseTableViewCell {

    // MARK: - Static
    static let IDENTIFIER = "HIEventCell"

    static func <- (lhs: HIEventCell, rhs: Event) {
        lhs.titleLabel.text = rhs.name
        rhs.locations.forEach { (location) in
            if let location = location as? Location {
                let label = UILabel()
                label.text = location.name
            }
        }
    }

    // MARK: - Properties
    var favoritedButton = UIButton()
    var titleLabel = UILabel()
    var locationsStackView = UIStackView()

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


        favoritedButton.setImage(#imageLiteral(resourceName: "Unfavorited"), for: .normal)
        favoritedButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        favoritedButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        favoritedButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true


        let disclosureIndicatorView = UIImageView(image: #imageLiteral(resourceName: "DisclosureIndicator"))
        disclosureIndicatorView.contentMode = .center
        disclosureIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(disclosureIndicatorView)
        disclosureIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        disclosureIndicatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        disclosureIndicatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        disclosureIndicatorView.widthAnchor.constraint(equalToConstant: 65).isActive = true

        
        // TODO: locationsStackView.alignment
        locationsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(locationsStackView)
        locationsStackView.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        locationsStackView.trailingAnchor.constraint(equalTo: disclosureIndicatorView.leadingAnchor).isActive = true
        locationsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true


        titleLabel.textColor = HIColor.darkIndigo
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationsStackView.addArrangedSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - UITableViewCell
extension HIEventCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        locationsStackView.arrangedSubviews.forEach { (view) in
            if view != titleLabel {
                locationsStackView.removeArrangedSubview(view)
            }
        }
    }
}

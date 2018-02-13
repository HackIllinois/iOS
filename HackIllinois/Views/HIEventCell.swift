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
    // MARK: - Properties
    var favoritedButton = UIButton()
    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = HIApplication.Color.paleBlue

        containerView.backgroundColor = HIApplication.Color.white
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

        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: disclosureIndicatorView.leadingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Population
extension HIEventCell {
    private static func labelFor(_ event: Event) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = event.name
        titleLabel.textColor = HIApplication.Color.darkIndigo
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return titleLabel
    }

    private static func labelFor(_ location: Location) -> UILabel {
        let locationLabel = UILabel()
        locationLabel.text = location.name
        locationLabel.textColor = HIApplication.Color.darkIndigo
        locationLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return locationLabel
    }

    static func heightForCell(with event: Event) -> CGFloat {
        return 73 + 21 * CGFloat(event.locations.count)
    }

    static func <- (lhs: HIEventCell, rhs: Event) {
        var contentStackViewHeight: CGFloat = 0
        let titleLabel = labelFor(rhs)
        contentStackViewHeight += titleLabel.intrinsicContentSize.height
        lhs.contentStackView.addArrangedSubview(titleLabel)
        if let locations = rhs.locations as? Set<Location> {
            for location in locations {
                let locationLabel = labelFor(location)
                contentStackViewHeight += locationLabel.intrinsicContentSize.height + 3
                lhs.contentStackView.addArrangedSubview(locationLabel)
            }
        }
        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }
}

// MARK: - UITableViewCell
extension HIEventCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

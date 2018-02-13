//
//  HILoginSelectionHeader.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HILoginSelectionHeader: UITableViewHeaderFooterView {
    // MARK: - Properties
    var titleLabel = UILabel()

    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let containerView = UIView()
        containerView.backgroundColor = HIApplication.Color.paleBlue
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true

        titleLabel.textColor = HIApplication.Color.hotPink
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 29).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -29).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

}

// MARK: - UITableViewHeaderFooterView
extension HILoginSelectionHeader {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

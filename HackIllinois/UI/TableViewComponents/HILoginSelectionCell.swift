//
//  HILoginSelectionCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HILoginSelectionCellDelegate: class {

}

class HILoginSelectionCell: HIBaseTableViewCell {
    // MARK: - Properties
    weak var delegate: HILoginSelectionCellDelegate?

    override var defaultColor: UIColor {
        return HIApplication.Palette.current.background
    }

    var titleLabel = UILabel()
    var separatorView = HIView(style: .separator)
    var activityIndicator = UIActivityIndicatorView()

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = HIApplication.Palette.current.background

        containerView = contentView

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorView)
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -23).isActive = true

        activityIndicator.color = HIApplication.Palette.current.accent
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -23).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

        titleLabel.textColor = HIApplication.Palette.current.primary
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        titleLabel.trailingAnchor.constraint(equalTo: activityIndicator.leadingAnchor, constant: -8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - UITableViewCell
extension HILoginSelectionCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        separatorView.isHidden = false
        activityIndicator.isHidden = true
    }
}

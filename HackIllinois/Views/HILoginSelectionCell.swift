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

    static let IDENTIFIER = "HILoginSelectionCell"

    // MARK: - Properties
    weak var delegate: HILoginSelectionCellDelegate?

    override var defaultColor: UIColor {
        return HIColor.paleBlue
    }

    var titleLabel = UILabel()
    var indicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = HIColor.paleBlue

        containerView = contentView

        indicatorView.backgroundColor = HIColor.hotPink
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(indicatorView)
        indicatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -23).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true


        activityIndicator.color = HIColor.hotPink
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -23).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true


        titleLabel.textColor = HIColor.darkIndigo
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
        indicatorView.isHidden = false
        activityIndicator.stopAnimating()
    }
}

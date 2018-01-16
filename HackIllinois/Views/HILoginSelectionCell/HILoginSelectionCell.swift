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
        return HIColor.paleBlue
    }

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
}

// MARK: - Actions
extension HILoginSelectionCell {
    @IBAction func deleteButtonPressed(sender: Any?) {

    }
}

// MARK: - UITableViewCell
extension HILoginSelectionCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/4)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        indicatorView.isHidden = false
        deleteButton.isHidden = true
    }
}

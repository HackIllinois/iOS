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
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
}

// MARK: - UITableViewHeaderFooterView
extension HILoginSelectionHeader {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

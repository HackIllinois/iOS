//
//  HITagCollectionViewCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/6/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITagCollectionViewCell: UICollectionViewCell {
//    private var tagLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        $0.font = UIFont(size: 14)
//        return label
//    }()
    var tagLabel = HILabel(style: .profileInterests)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor(red: 0.933, green: 0.424, blue: 0.447, alpha: 1).cgColor
        self.layer.cornerRadius = 15
//        self.text.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        self.font = UIFont(size: 14)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagLabel)
        tagLabel.constrain(to: safeAreaLayoutGuide, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Population
extension HITagCollectionViewCell {
    static func <- (lhs: HITagCollectionViewCell, rhs: String) {
        lhs.tagLabel.text = rhs
    }
}

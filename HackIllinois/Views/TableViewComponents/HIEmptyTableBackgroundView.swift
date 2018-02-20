//
//  HIEmptyTableBackgroundView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/6/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import UIKit

class HIEmptyTableBackgroundView: UIView {
    init() {
        super.init(frame: .zero)
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "EmptyTableView"))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        NSLayoutConstraint(item: backgroundImageView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 0.7,
                           constant: 0.0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

//
//  HIBaseTableViewCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIBaseTableViewCell: UITableViewCell {
    // MARK: - Properties
    var selectedColor: UIColor {
        return HIApplication.Color.hotPink
    }

    var highlightedColor: UIColor {
        return HIApplication.Color.lightPeriwinkle
    }

    var defaultColor: UIColor {
        return HIApplication.Color.white
    }

    var containerView = UIView()
}

// MARK: - UITableViewCell
extension HIBaseTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.backgroundColor = HIApplication.Color.white
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.containerView.backgroundColor = highlighted ? self.highlightedColor : self.defaultColor
        }
        animator.startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.containerView.backgroundColor = selected ? self.selectedColor : self.defaultColor
        }
        animator.startAnimation()
    }
}

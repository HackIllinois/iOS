//
//  HITableViewCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HITableViewCell: UITableViewCell {
    // MARK: - Outlets
    var containerView: UIView!
}

// MARK: - UITableViewCell
extension HITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.backgroundColor = HIColor.white
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.containerView.backgroundColor = highlighted ? HIColor.lightPeriwinkle : HIColor.white
        }
        animator.startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.containerView.backgroundColor = selected ? HIColor.bubbleGumPink : HIColor.white
        }
        animator.startAnimation()
    }
}

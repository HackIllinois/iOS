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
        return HIColor.bubbleGumPink
    }

    var highlightedColor: UIColor {
        return HIColor.lightPeriwinkle
    }

    var defaultColor: UIColor {
        return HIColor.white
    }

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
}

// MARK: - UITableViewCell
extension HIBaseTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.backgroundColor = HIColor.white
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

// MARK: - StoryboardIdentifiable
extension UITableViewCell: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - StoryboardIdentifiable
extension UITableViewHeaderFooterView: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

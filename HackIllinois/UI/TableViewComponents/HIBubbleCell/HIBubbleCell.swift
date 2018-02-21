//
//  HIBubbleCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIBubbleCell: UITableViewCell {
    // MARK: - Properties
    var selectedColor: UIColor {
        return HIApplication.Palette.current.accent
    }

    var highlightedColor: UIColor {
        return HIApplication.Palette.current.actionBackground
    }

    var defaultColor: UIColor {
        return HIApplication.Palette.current.contentBackground
    }

    var bubbleView = HIView(style: .content)

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        contentView.backgroundColor = HIApplication.Palette.current.background
    }

    // MARK: - UITableViewCell
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleView.backgroundColor = HIApplication.Palette.current.contentBackground
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.bubbleView.backgroundColor = highlighted ? self.highlightedColor : self.defaultColor
        }
        animator.startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.bubbleView.backgroundColor = selected ? self.selectedColor : self.defaultColor
        }
        animator.startAnimation()
    }
}

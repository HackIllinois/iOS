//
//  HILoginSelectionCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

protocol HILoginSelectionCellDelegate: class {

}

class HILoginSelectionCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: HILoginSelectionCellDelegate?

    var titleLabel = HILabel(style: .loginSelection)
    var separatorView = HIView(style: .separator)

    var defaultColor: UIColor {
        return HIApplication.Palette.current.background
    }

    var activeColor: UIColor {
        return HIApplication.Palette.current.actionBackground
    }

    var animator: UIViewPropertyAnimator?

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        separatorView.constrain(to: contentView, trailingInset: -24, bottomInset: 0, leadingInset: 24)

        contentView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor).isActive = true
        titleLabel.constrain(to: contentView, topInset: 0, trailingInset: 0, leadingInset: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc  func refreshForThemeChange() {
        contentView.backgroundColor = HIApplication.Palette.current.background
    }
}

// MARK: - UITableViewCell
extension HILoginSelectionCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        separatorView.isHidden = false
    }

    // MARK: - UITableViewCell
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setActive(highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setActive(selected)
    }

    func setActive(_ active: Bool) {
        let finalColor = active ? activeColor : defaultColor
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator?.addAnimations { [weak self] in
            self?.backgroundColor = finalColor
            self?.contentView.backgroundColor = finalColor
        }
        animator?.startAnimation()
    }

}

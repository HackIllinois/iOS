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
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

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

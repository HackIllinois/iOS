//
//  HILoginSelectionCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/14/18.
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
//    var separatorView = HIView(style: .separator) TODO: Remove separator code

    var defaultColor: UIColor {
        return (\HIAppearance.baseBackground).value
    }

    var activeColor: UIColor {
        return (\HIAppearance.action).value
    }

    var animator: UIViewPropertyAnimator?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

//        separatorView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(separatorView)
//        separatorView.constrain(to: contentView, trailingInset: 0, bottomInset: 0, leadingInset: 0)
//        separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        contentView.addSubview(titleLabel)
//        titleLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
//        titleLabel.constrain(to: contentView, topInset: 0, trailingInset: 0, leadingInset: 0)

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
    @objc func refreshForThemeChange() {
        contentView.backgroundColor <- \.baseBackground
    }
}

// MARK: - UITableViewCell
extension HILoginSelectionCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
//        separatorView.isHidden = false
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
        let titleColor = active ? activeColor.cgColor : UIColor.clear.cgColor //TODO: Replace red with actual colors
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator?.addAnimations { [weak self] in
//            self?.backgroundColor = finalColor
            self?.titleLabel.layer.backgroundColor = titleColor
//            self?.contentView.backgroundColor = finalColor
        }
        animator?.startAnimation()
    }
}

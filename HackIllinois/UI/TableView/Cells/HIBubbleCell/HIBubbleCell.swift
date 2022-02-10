//
//  HIBubbleCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIBubbleCell: UITableViewCell {
    // MARK: - Properties
    var animator: UIViewPropertyAnimator?

    var bubbleView = HIView {
        $0.backgroundHIColor = \.contentBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.3607843137, alpha: 0.3984650088)
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 1.0
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.constrain(to: safeAreaLayoutGuide, topInset: 5, trailingInset: -25, bottomInset: -5, leadingInset: 25)

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
        contentView.backgroundColor <- \.clear
    }

    // MARK: - UITableViewCell
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setActive(highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        setActive(selected)
    }

    func setActive(_ active: Bool) {
        let finalColor: HIColor = active ? \.action : \.contentBackground
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator?.addAnimations { [weak self] in
            self?.bubbleView.backgroundColor = finalColor.value
        }
        animator?.startAnimation()
    }
}

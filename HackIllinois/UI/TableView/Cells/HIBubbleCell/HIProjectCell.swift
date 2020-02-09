//
//  HIProjectCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/25/19.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

protocol HIProjectCellDelegate: class {
    func projectCellDidSelectFavoriteButton(_ projectCell: HIProjectCell)
}

class HIProjectCell: HIBubbleCell {
    // MARK: - Properties
    let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }

    var contentStackView = UIStackView()
    var contentStackViewHeight = NSLayoutConstraint()
    
    var tagScrollView = UIScrollView()
    var tagStackView = UIStackView()
    var spaceView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 12).isActive = true
        $0.backgroundHIColor = \.clear
    }
    var indexPath: IndexPath?
    weak var delegate: HIProjectCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        bubbleView.addSubview(favoritedButton)
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        favoritedButton.constrain(to: bubbleView, topInset: 0, trailingInset: 0, bottomInset: 0)

        // add bubble view
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        contentStackViewHeight = contentStackView.heightAnchor.constraint(equalToConstant: 0)
        contentStackViewHeight.isActive = true
        
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.showsHorizontalScrollIndicator = false
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        tagStackView.axis = .horizontal
        tagStackView.alignment = .fill
        tagStackView.distribution = .equalSpacing
        tagStackView.spacing = 5.0
        tagScrollView.addSubview(tagStackView)
        
        tagStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagStackView.bottomAnchor.constraint(equalTo: tagScrollView.bottomAnchor).isActive = true
        tagStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - Actions
extension HIProjectCell {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        delegate?.projectCellDidSelectFavoriteButton(self)
    }
}

// MARK: - Population
extension HIProjectCell {
    static func heightForCell(with project: Project) -> CGFloat {
        return 98 + 21 * 1 //Update in UI: Projects have one location
    }

    static func <- (lhs: HIProjectCell, rhs: Project) {
        lhs.favoritedButton.isActive = rhs.favorite
        var contentStackViewHeight: CGFloat = 0
        let titleLabel = HILabel(style: .project)
        titleLabel.text = rhs.name
        contentStackViewHeight += titleLabel.intrinsicContentSize.height
        lhs.contentStackView.addArrangedSubview(titleLabel)
        let roomLabel = HILabel(style: .description)
        roomLabel.text = "Table #" + String(rhs.number) //Update in UI: Phrasing not finalized
        contentStackViewHeight += roomLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(roomLabel)
        let locationLabel = HILabel(style: .description)
        locationLabel.text = "Meeting Room: " + rhs.room //Update in UI: Phrasing not finalized
        contentStackViewHeight += locationLabel.intrinsicContentSize.height + 3
        lhs.contentStackView.addArrangedSubview(locationLabel)
        lhs.contentStackView.addArrangedSubview(lhs.spaceView)
        populateTagLabels(stackView: lhs.tagStackView, tagsString: rhs.tags)
        lhs.tagStackView.layoutIfNeeded()
        contentStackViewHeight += lhs.tagStackView.frame.height + 10
        lhs.contentStackView.addArrangedSubview(lhs.tagScrollView)
        lhs.contentStackViewHeight.constant = contentStackViewHeight
    }
    
    static func populateTagLabels(stackView: UIStackView, tagsString: String) {
        let tags = tagsString.components(separatedBy: ",")
        for tag in tags {
            let tagLabel = HILabel {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.textAlignment = .center
                $0.font = HIAppearance.Font.contentText
                $0.backgroundHIColor = \.clear
                switch tag {
                case "Web Development":
                    $0.text = "Web Dev    "
                    $0.layer.backgroundColor = UIColor(red: 0.42, green: 0.682, blue: 0.773, alpha: 1).cgColor
                    $0.textHIColor = \.whiteTagFont
                case "Systems":
                    $0.text = "Systems    "
                    $0.layer.backgroundColor = UIColor(red: 0.643, green: 0.231, blue: 0.361, alpha: 1).cgColor
                    $0.textHIColor = \.whiteTagFont
                case "Languages":
                    $0.text = "Languages    "
                    $0.layer.backgroundColor = UIColor(red: 0.659, green: 0.796, blue: 0.718, alpha: 1).cgColor
                    $0.textHIColor = \.tagFont
                case "Data Science":
                    $0.text = "Data Sci    "
                    $0.layer.backgroundColor = UIColor(red: 0.886, green: 0.545, blue: 0.475, alpha: 1).cgColor
                    $0.textHIColor = \.tagFont
                default:
                    $0.text = tag
                    $0.textColor = .white
                    $0.layer.backgroundColor = UIColor.systemTeal.cgColor
                }
            }
            tagLabel.layer.cornerRadius = 8.0
            stackView.addArrangedSubview(tagLabel)
        }
    }
}

// MARK: - UITableViewCell
extension HIProjectCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritedButton.isActive = false
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        tagStackView.arrangedSubviews.forEach{ (view) in
            tagStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

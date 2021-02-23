//
//  HIGroupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData

class HIGroupViewController: HIGroupListViewController {
    // MARK: - Properties
    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )

    @objc dynamic override func setUpBackgroundView() {
            super.setUpBackgroundView()
            backgroundView.image = #imageLiteral(resourceName: "GroupMatching")
        }
}

// MARK: - UITabBarItem Setup
extension HIGroupViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "project"), tag: 0)
    }
}

// MARK: - Actions
extension HIGroupViewController {
    func animateReload() {
        if let tableView = tableView, !tableView.visibleCells.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    @objc func openPopup() {
        let popupView = HIGroupPopupViewController()
        popupView.modalPresentationStyle = .overCurrentContext
        popupView.modalTransitionStyle = .crossDissolve
        present(popupView, animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIGroupViewController {
    override func loadView() {
        super.loadView()

        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.spacing = 15
        horizontalStackView.alignment = .center
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let sortLabel = HILabel(style: .sortText)
        sortLabel.text = "Sort: "
        horizontalStackView.addArrangedSubview(sortLabel)

        let groupStatusButton = HIButton {
            $0.layer.cornerRadius = 15
            $0.titleLabel?.font = HIAppearance.Font.sortingText
            $0.backgroundHIColor = \.buttonViewBackground
            $0.titleHIColor = \.action
            $0.title = "Group Status"
            //$0.activeImage = #imageLiteral(resourceName: "DropDown")
            //$0.baseImage = #imageLiteral(resourceName: "DropDown")
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: $0.frame.size.width - 15, bottom: 0, right: 0)
            //$0.titleEdgeInsets = UIEdgeInsets(top: 0, left: ($0.imageView?.frame.width)! + 15, bottom: 0, right: 10)
        }
        horizontalStackView.addArrangedSubview(groupStatusButton)

        let skillSortButton = HIButton {
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
            $0.titleLabel?.font = HIAppearance.Font.sortingText
            $0.backgroundHIColor = \.buttonViewBackground
            $0.titleHIColor = \.action
            $0.title = "Skills"
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            $0.addTarget(self, action: #selector(self.openPopup), for: .touchUpInside)
        }
        horizontalStackView.addArrangedSubview(skillSortButton)

        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }
}

// MARK: - UINavigationItem Setup
extension HIGroupViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "Group Matching"
    }
}

// MARK: - UITableViewDelegate
extension HIGroupViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}

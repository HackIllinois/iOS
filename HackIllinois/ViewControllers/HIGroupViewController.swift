//
//  HIGroupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData

class HIGroupViewController: HIGroupListViewController {

    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Profile> = {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "firstName", ascending: true)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: HICoreDataController.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    private let transparentBackground = HIView()
    private let groupStatusTable = HITableView()
    private var selectedButton = HIButton()
    let horizontalStackView = UIStackView()
    var buttonPresses = 0
    private var interests = Set<String>()
    private var selectedRows = Set<Int>()

    @objc dynamic override func setUpBackgroundView() {
            super.setUpBackgroundView()
            backgroundView.image = #imageLiteral(resourceName: "GroupMatching")
        }
}

// MARK: - UITabBarItem Setup
extension HIGroupViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "matching"), tag: 0)
    }
}

// MARK: - Actions
extension HIGroupViewController {
    func animateReload() {
        try? fetchedResultsController.performFetch()
        animateTableViewReload()
        if let tableView = tableView, !tableView.visibleCells.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    @objc func openPopup() {
        let popupView = HIGroupPopupViewController()
        popupView.modalPresentationStyle = .overCurrentContext
        popupView.modalTransitionStyle = .crossDissolve
        popupView.delegate = self
        popupView.selectedRows = selectedRows
        present(popupView, animated: true, completion: nil)
    }

    @objc func addDropdownView(button: HIButton) {
        buttonPresses += 1
        view.layoutIfNeeded()
        //let frames = button.frame
        let window = UIApplication.shared.keyWindow
        transparentBackground.frame = window?.frame ?? self.view.frame

        groupStatusTable.frame = CGRect(x: button.frame.origin.x + horizontalStackView.frame.origin.x, y: button.frame.origin.y + horizontalStackView.frame.origin.y, width: button.frame.width, height: 0)
        groupStatusTable.layer.cornerRadius = 15
        self.view.addSubview(groupStatusTable)
        groupStatusTable.backgroundColor = UIColor.white

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeDropdown))
        transparentBackground.addGestureRecognizer(tapGesture)

        if buttonPresses % 2 != 0 {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusTable.frame = CGRect(x: button.frame.origin.x + self.horizontalStackView.frame.origin.x, y: button.frame.origin.y + self.horizontalStackView.frame.origin.y, width: button.frame.width, height: 100)
            }, completion: nil)
        } else {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusTable.frame = CGRect(x: button.frame.origin.x + self.horizontalStackView.frame.origin.x, y: button.frame.origin.y + self.horizontalStackView.frame.origin.y, width: button.frame.width, height: 0)
            }, completion: nil)
        }
    }

    @objc func removeDropdown() {
        let frames = selectedButton.frame
        HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.groupStatusTable.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}

// MARK: - UIViewController
extension HIGroupViewController {
    override func loadView() {
        super.loadView()

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
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: $0.frame.size.width - 15, bottom: 0, right: 0)
            $0.addTarget(self, action: #selector(self.addDropdownView(button:)), for: .touchUpInside)
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
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
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

// MARK: - HIGroupPopupViewDelegate
extension HIGroupViewController: HIGroupPopupViewDelegate {
    func updateInterests(_ groupPopupCell: HIGroupPopupCell) {
        guard let indexPath = groupPopupCell.indexPath, let interest = groupPopupCell.interestLabel.text else { return }
        if groupPopupCell.selectedImageView.isHidden {
            selectedRows.insert(indexPath.row)
            interests.insert(interest)
        } else {
            selectedRows.remove(indexPath.row)
            interests.remove(interest)
        }
        interestParams = Array(interests)
        HIProfileDataSource.refresh(teamStatus: teamStatusParam, interests: interestParams)
    }
}

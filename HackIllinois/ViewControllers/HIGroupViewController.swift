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
    //let groupStatusOptions = ["Looking for Team", "Team Looking for Members"]
    //var hiGroupStatusOptions: [HIGroupStatusOptions] = []
    private let lookingForMember = HIButton {
        $0.title = "Team Looking for Members"
        $0.titleLabel?.font = HIAppearance.Font.groupStatus
        $0.baseImage = #imageLiteral(resourceName: "UnselectedGroupStatus")
        $0.activeImage = #imageLiteral(resourceName: "SelectedGroupStatus")
    }
    private let lookingForTeam = HIButton {
        $0.title = "Looking for a Team"
        $0.titleLabel?.font = HIAppearance.Font.groupStatus
        $0.baseImage = #imageLiteral(resourceName: "UnselectedGroupStatus")
        $0.activeImage = #imageLiteral(resourceName: "SelectedGroupStatus")
    }
    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    private let transparentBackground = HIView()
    private var selectedButton = HIButton()
    //private let groupStatusTable = HITableView()
    let groupStatusDropdown = UIStackView()
    let horizontalStackView = UIStackView()
    var shouldPresentDropdown: Bool = false
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
        shouldPresentDropdown.toggle()
        groupStatusDropdown.layer.cornerRadius = 15
        groupStatusDropdown.axis = .vertical
        groupStatusDropdown.distribution = .fillProportionally
        groupStatusDropdown.spacing = 15
        groupStatusDropdown.alignment = .leading
        groupStatusDropdown.translatesAutoresizingMaskIntoConstraints = false
        groupStatusDropdown.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4078431373, blue: 0.6509803922, alpha: 1)
        self.view.addSubview(groupStatusDropdown)
        self.view.insertSubview(groupStatusDropdown, belowSubview: self.horizontalStackView)
        
        view.layoutIfNeeded()
        let window = UIApplication.shared.keyWindow
        transparentBackground.frame = window?.frame ?? self.view.frame

        groupStatusDropdown.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: button.frame.width, height: 0)
        groupStatusDropdown.addArrangedSubview(lookingForTeam)
        groupStatusDropdown.addArrangedSubview(lookingForMember)
        if shouldPresentDropdown {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusDropdown.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: button.frame.width, height: 100)
            }, completion: nil)
        } else {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusDropdown.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: button.frame.width, height: 0)
            }, completion: nil)
        }
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
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = .zero
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 5
            $0.addTarget(self, action: #selector(self.addDropdownView(button:)), for: .touchUpInside)
        }
        horizontalStackView.addArrangedSubview(groupStatusButton)

        let skillSortButton = HIButton {
            $0.layer.cornerRadius = 15
            //$0.layer.masksToBounds = true
            $0.titleLabel?.font = HIAppearance.Font.sortingText
            $0.backgroundHIColor = \.buttonViewBackground
            $0.titleHIColor = \.action
            $0.title = "Skills"
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = .zero
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 5
            $0.addTarget(self, action: #selector(self.openPopup), for: .touchUpInside)
        }
        horizontalStackView.addArrangedSubview(skillSortButton)

        let tableView = HITableView()
        view.insertSubview(tableView, belowSubview: horizontalStackView)
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

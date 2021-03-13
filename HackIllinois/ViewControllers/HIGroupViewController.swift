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
    private let lookingForTeam = HIButton {
        $0.title = "Looking for Team"
        $0.titleLabel?.font = HIAppearance.Font.groupStatus
        $0.titleLabel?.numberOfLines = 0
        $0.baseImage = #imageLiteral(resourceName: "UnselectedGroupStatus")
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(getProfilesLookingForTeam), for: .touchUpInside)
    }
    private let lookingForMember = HIButton {
        $0.title = "Looking for Members"
        $0.titleLabel?.font = HIAppearance.Font.groupStatus
        $0.titleLabel?.numberOfLines = 0
        $0.baseImage = #imageLiteral(resourceName: "UnselectedGroupStatus")
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(getProfilesLookingForMember), for: .touchUpInside)
    }
    private let groupStatusButton = HIButton {
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
        $0.addTarget(self, action: #selector(addDropdownView), for: .touchUpInside)
    }
    private let skillSortButton = HIButton {
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Skills"
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = .zero
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.addTarget(self, action: #selector(openPopup), for: .touchUpInside)
    }
    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    private let transparentBackground = HIView()
    private var selectedButton = HIButton()
    private let groupStatusDropdown = UIView()
    let horizontalStackView = UIStackView()
    var shouldActivateLookingForMember: Bool = false
    var shouldActivateLookingForTeam: Bool = false
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

    @objc func addDropdownView() {
        shouldPresentDropdown.toggle()
        if shouldPresentDropdown {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusDropdown.isHidden = false
            }, completion: nil)
        } else {
            HIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.groupStatusDropdown.isHidden = true
            }, completion: nil)
        }
    }

    @objc func getProfilesLookingForTeam() {
        shouldActivateLookingForTeam.toggle()
        if shouldActivateLookingForTeam {
            lookingForTeam.setImage(#imageLiteral(resourceName: "SelectedGroupStatus"), for: .normal)
        } else {
            lookingForTeam.setImage(#imageLiteral(resourceName: "UnselectedGroupStatus"), for: .normal)
        }
    }

    @objc func getProfilesLookingForMember() {
        shouldActivateLookingForMember.toggle()
        if shouldActivateLookingForMember {
            lookingForMember.setImage(#imageLiteral(resourceName: "SelectedGroupStatus"), for: .normal)
        } else {
            lookingForMember.setImage(#imageLiteral(resourceName: "UnselectedGroupStatus"), for: .normal)
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
        sortLabel.text = "Filter: "
        horizontalStackView.addArrangedSubview(sortLabel)
        horizontalStackView.addArrangedSubview(groupStatusButton)
        horizontalStackView.addArrangedSubview(skillSortButton)

        view.insertSubview(groupStatusDropdown, belowSubview: horizontalStackView)
        groupStatusDropdown.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4078431373, blue: 0.6509803922, alpha: 1)
        groupStatusDropdown.layer.cornerRadius = 15
        groupStatusDropdown.clipsToBounds = true
        groupStatusDropdown.addSubview(lookingForTeam)
        groupStatusDropdown.addSubview(lookingForMember)
        lookingForTeam.leadingAnchor.constraint(equalTo: groupStatusButton.leadingAnchor).isActive = true
        lookingForTeam.trailingAnchor.constraint(equalTo: groupStatusButton.trailingAnchor).isActive = true
        lookingForTeam.topAnchor.constraint(equalTo: groupStatusButton.bottomAnchor).isActive = true
        lookingForTeam.heightAnchor.constraint(equalToConstant: 50).isActive = true

        lookingForMember.leadingAnchor.constraint(equalTo: lookingForTeam.leadingAnchor).isActive = true
        lookingForMember.trailingAnchor.constraint(equalTo: groupStatusButton.trailingAnchor).isActive = true
        lookingForMember.topAnchor.constraint(equalTo: lookingForTeam.bottomAnchor).isActive = true
        lookingForMember.heightAnchor.constraint(equalTo: lookingForTeam.heightAnchor).isActive = true
        groupStatusDropdown.isHidden = true

        let tableView = HITableView()
        view.insertSubview(tableView, belowSubview: groupStatusDropdown)
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

    override func viewDidLayoutSubviews() {
        groupStatusDropdown.frame = CGRect(x: groupStatusButton.frame.origin.x + horizontalStackView.frame.origin.x, y: groupStatusButton.frame.origin.y + horizontalStackView.frame.origin.y, width: groupStatusButton.frame.width, height: 135)
    }
}

// MARK: - UINavigationItem Setup
extension HIGroupViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "GROUP MATCHING"
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

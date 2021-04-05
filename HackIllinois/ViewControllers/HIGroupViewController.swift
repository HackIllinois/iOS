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
    private let errorLabel = HILabel(style: .error) {
        $0.text = "You need to log out of your current account and log in as an attendee to see other profiles."
    }
    private let lookingForTeamContainer = UIView()
    private let lookingForTeamLabel = HILabel(style: .groupStatusFilter) {
        $0.text = "Looking For Team"
    }
    private let lookingForTeamSelector = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.hiImage = \.unselectedGroupStatus
    }
    private let lookingForMemberContainer = UIView()
    private let lookingForMemberLabel = HILabel(style: .groupStatusFilter) {
        $0.text = "Looking For Members"
    }
    private let lookingForMemberSelector = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.hiImage = \.unselectedGroupStatus
    }
    private let groupStatusButton = HIButton {
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = HIAppearance.Font.sortingText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Team Status"
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: $0.frame.size.width - 15, bottom: 0, right: 0)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = .zero
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.addTarget(self, action: #selector(animateDropdownView), for: .touchUpInside)
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
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES")
    private let allPredicate = NSPredicate(format: "favorite == YES OR favorite == NO")
    private let transparentBackground = HIView()
    private var selectedButton = HIButton()
    private let groupStatusDropdown = UIView()
    let horizontalStackView = UIStackView()
    var shouldActivateLookingForMember: Bool = false
    var shouldActivateLookingForTeam: Bool = false
    var shouldPresentDropdown: Bool = false
    private var selectedRows = Set<Int>()
    private var interests = Set<String>()
    private var statuses = Set<String>()

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

    @objc func didSelectFavoritesIcon(_ sender: UIBarButtonItem) {
        onlyFavorites = !onlyFavorites
        sender.image = onlyFavorites ? #imageLiteral(resourceName: "MenuFavorited") : #imageLiteral(resourceName: "MenuUnfavorited")
        updatePredicate()
        animateReload()
    }

    func updatePredicate() {
        fetchedResultsController.fetchRequest.predicate = currentPredicate()
    }

    func currentPredicate() -> NSPredicate {
        if onlyFavorites {
            return onlyFavoritesPredicate
        } else {
            return allPredicate
        }
    }

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

    @objc func animateDropdownView() {
        shouldPresentDropdown.toggle()
        if shouldPresentDropdown {
            groupStatusDropdown.isHidden = false
        } else {
            groupStatusDropdown.isHidden = true
        }
    }

    @objc func getProfilesLookingForTeam() {
        shouldActivateLookingForTeam.toggle()
        guard let status = lookingForTeamLabel.text?.uppercased() else { return }
        let modifiedStatus = status.replacingOccurrences(of: " ", with: "_")

        if shouldActivateLookingForTeam {
            lookingForTeamSelector.changeImage(newImage: \.selectedGroupStatus)
            statuses.insert(modifiedStatus)
        } else {
            lookingForTeamSelector.changeImage(newImage: \.unselectedGroupStatus)
            statuses.remove(modifiedStatus)
        }
        teamStatusParams = Array(statuses)
        HIProfileDataSource.refresh(teamStatus: teamStatusParams, interests: interestParams)
    }

    @objc func getProfilesLookingForMember() {
        shouldActivateLookingForMember.toggle()
        guard let status = lookingForMemberLabel.text?.uppercased() else { return }
        let modifiedStatus = status.replacingOccurrences(of: " ", with: "_")

        if shouldActivateLookingForMember {
            lookingForMemberSelector.changeImage(newImage: \.selectedGroupStatus)
            statuses.insert(modifiedStatus)
        } else {
            lookingForMemberSelector.changeImage(newImage: \.unselectedGroupStatus)
            statuses.remove(modifiedStatus)
        }
        teamStatusParams = Array(statuses)
        HIProfileDataSource.refresh(teamStatus: teamStatusParams, interests: interestParams)
    }
}

// MARK: - UIViewController
extension HIGroupViewController {
    override func loadView() {
        super.loadView()
        if HIApplicationStateController.shared.isGuest {
            layoutErrorLabel()
        } else {
            layoutProfiles()
        }
    }

    func layoutErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

    func layoutProfiles() {
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

        lookingForTeamContainer.translatesAutoresizingMaskIntoConstraints = false
        lookingForMemberContainer.translatesAutoresizingMaskIntoConstraints = false

        let lookingForTeamRecognizer = UITapGestureRecognizer(target: self, action: #selector(getProfilesLookingForTeam))
        lookingForTeamContainer.isUserInteractionEnabled = true
        lookingForTeamContainer.addGestureRecognizer(lookingForTeamRecognizer)

        let lookingForMemberRecognizer = UITapGestureRecognizer(target: self, action: #selector(getProfilesLookingForMember))
        lookingForMemberContainer.isUserInteractionEnabled = true
        lookingForMemberContainer.addGestureRecognizer(lookingForMemberRecognizer)

        groupStatusDropdown.addSubview(lookingForTeamContainer)
        groupStatusDropdown.addSubview(lookingForMemberContainer)
        lookingForTeamContainer.leadingAnchor.constraint(equalTo: groupStatusButton.leadingAnchor).isActive = true
        lookingForTeamContainer.trailingAnchor.constraint(equalTo: groupStatusButton.trailingAnchor).isActive = true
        lookingForTeamContainer.topAnchor.constraint(equalTo: groupStatusButton.bottomAnchor).isActive = true
        lookingForTeamContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true

        lookingForTeamContainer.addSubview(lookingForTeamSelector)
        lookingForTeamContainer.addSubview(lookingForTeamLabel)
        lookingForTeamSelector.topAnchor.constraint(equalTo: lookingForTeamContainer.topAnchor).isActive = true
        lookingForTeamSelector.centerYAnchor.constraint(equalTo: lookingForTeamContainer.centerYAnchor).isActive = true
        lookingForTeamSelector.leadingAnchor.constraint(equalTo: lookingForTeamContainer.leadingAnchor, constant: 5).isActive = true
        lookingForTeamSelector.widthAnchor.constraint(equalToConstant: 20).isActive = true

        lookingForTeamLabel.topAnchor.constraint(equalTo: lookingForTeamSelector.topAnchor).isActive = true
        lookingForTeamLabel.centerYAnchor.constraint(equalTo: lookingForTeamSelector.centerYAnchor).isActive = true
        lookingForTeamLabel.leadingAnchor.constraint(equalTo: lookingForTeamSelector.trailingAnchor, constant: 5).isActive = true
        lookingForTeamLabel.trailingAnchor.constraint(equalTo: lookingForTeamContainer.trailingAnchor).isActive = true

        lookingForMemberContainer.leadingAnchor.constraint(equalTo: lookingForTeamContainer.leadingAnchor).isActive = true
        lookingForMemberContainer.trailingAnchor.constraint(equalTo: groupStatusButton.trailingAnchor).isActive = true
        lookingForMemberContainer.topAnchor.constraint(equalTo: lookingForTeamContainer.bottomAnchor, constant: 5).isActive = true
        lookingForMemberContainer.heightAnchor.constraint(equalTo: lookingForTeamContainer.heightAnchor).isActive = true

        lookingForMemberContainer.addSubview(lookingForMemberSelector)
        lookingForMemberContainer.addSubview(lookingForMemberLabel)
        lookingForMemberSelector.topAnchor.constraint(equalTo: lookingForMemberContainer.topAnchor).isActive = true
        lookingForMemberSelector.centerYAnchor.constraint(equalTo: lookingForMemberContainer.centerYAnchor).isActive = true
        lookingForMemberSelector.leadingAnchor.constraint(equalTo: lookingForMemberContainer.leadingAnchor, constant: 5).isActive = true
        lookingForMemberSelector.widthAnchor.constraint(equalToConstant: 20).isActive = true

        lookingForMemberLabel.topAnchor.constraint(equalTo: lookingForMemberSelector.topAnchor).isActive = true
        lookingForMemberLabel.centerYAnchor.constraint(equalTo: lookingForMemberSelector.centerYAnchor).isActive = true
        lookingForMemberLabel.leadingAnchor.constraint(equalTo: lookingForMemberSelector.trailingAnchor, constant: 5).isActive = true
        lookingForMemberLabel.trailingAnchor.constraint(equalTo: lookingForMemberContainer.trailingAnchor).isActive = true
        groupStatusDropdown.isHidden = true

        let tableView = HITableView()
        view.insertSubview(tableView, belowSubview: groupStatusDropdown)
        tableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        HIProfileDataSource.refresh(teamStatus: teamStatusParams, interests: interestParams, completion: endRefreshing)
    }

    override func viewDidLoad() {
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        setupRefreshControl()
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        groupStatusDropdown.frame = CGRect(x: groupStatusButton.frame.origin.x + horizontalStackView.frame.origin.x,
                                           y: groupStatusButton.frame.origin.y + horizontalStackView.frame.origin.y, width: groupStatusButton.frame.width, height: 120)
    }

    override func viewWillDisappear(_ animated: Bool) {
        shouldPresentDropdown = false
        groupStatusDropdown.isHidden = true
    }
}

// MARK: - UINavigationItem Setup
extension HIGroupViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "Team Matching"
        if !HIApplicationStateController.shared.isGuest {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuUnfavorited"), style: .plain, target: self, action: #selector(didSelectFavoritesIcon(_:)))
        }
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
        let modifiedInterest = interest.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "#", with: "%23").replacingOccurrences(of: "+", with: "%2b")
        if groupPopupCell.selectedImageView.isHidden {
            selectedRows.insert(indexPath.row)
            interests.insert(modifiedInterest)
        } else {
            selectedRows.remove(indexPath.row)
            interests.remove(modifiedInterest)
        }
        interestParams = Array(interests)
        HIProfileDataSource.refresh(teamStatus: teamStatusParams, interests: interestParams)
    }
}

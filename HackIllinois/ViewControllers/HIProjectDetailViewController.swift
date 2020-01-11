//
//  HIProjectDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/25/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import MapKit
import HIAPI
import APIManager

class HIProjectDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var project: Project?

    // MARK: Views
    private let projectDetailContainer = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let upperContainerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let titleLabel = HILabel(style: .project) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentTitle
    }

    private let numberLabel = HILabel(style: .description) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentText
    }

    private let descriptionLabel = HILabel(style: .description) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentText
        $0.numberOfLines = 0
    }
    private let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }

    // MARK: Constraints
    private var descriptionLabelHeight = NSLayoutConstraint()
    private var tableViewHeight = NSLayoutConstraint()
}

// MARK: - Actions
extension HIProjectDetailViewController {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        guard let project = project else { return }

        let changeFavoriteStatusRequest: APIRequest<ProjectFavorites> =
            sender.isActive ?
                HIAPI.ProjectService.unfavoriteBy(id: project.id) :
                HIAPI.ProjectService.favoriteBy(id: project.id)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    sender.isActive.toggle()
                    project.favorite.toggle()
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}

// MARK: - UIViewController
extension HIProjectDetailViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(projectDetailContainer)
        projectDetailContainer.constrain(to: view.safeAreaLayoutGuide, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        projectDetailContainer.addSubview(upperContainerView)
        upperContainerView.constrain(to: projectDetailContainer, topInset: 10, trailingInset: 0, leadingInset: 0)
        upperContainerView.constrain(height: 67)

        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        upperContainerView.addSubview(favoritedButton)
        favoritedButton.constrain(to: upperContainerView, topInset: 0, trailingInset: 0, bottomInset: 0)
        favoritedButton.constrain(width: 58)

        upperContainerView.addSubview(titleLabel)
        titleLabel.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: upperContainerView.leadingAnchor, constant: 12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: upperContainerView.centerYAnchor).isActive = true

        upperContainerView.addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: upperContainerView.leadingAnchor, constant: 12).isActive = true

        projectDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: upperContainerView.bottomAnchor, constant: 24).isActive = true
        descriptionLabel.constrain(to: projectDetailContainer, trailingInset: -12, leadingInset: 12)
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true

        let tableView = UITableView()
        tableView.backgroundColor <- \.contentBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        projectDetailContainer.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        tableView.constrain(to: projectDetailContainer, trailingInset: 0, bottomInset: -6, leadingInset: 0)
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let project = project else { return }
        titleLabel.text = project.name
        descriptionLabel.text = project.info //TODO: Update description to project
        favoritedButton.isActive = project.favorite
        numberLabel.text = "#\(project.number)"

        tableView?.reloadData()
        view.layoutIfNeeded()
        let targetSize = CGSize(width: descriptionLabel.frame.width, height: .greatestFiniteMagnitude)
        let neededSize = descriptionLabel.sizeThatFits(targetSize)
        descriptionLabelHeight.constant = neededSize.height
        tableViewHeight.constant = 1 * 160 //TODO: Projects have one location
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if project == nil {
            presentErrorController(title: "Uh oh", message: "Failed to load project.", dismissParentOnCompletion: true)
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIProjectDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "PROJECT DETAILS"
    }
}

// MARK: - UITableView Setup
extension HIProjectDetailViewController {
    override func setupTableView() {
        tableView?.alwaysBounceVertical = false
        tableView?.register(HIEventDetailLocationCell.self, forCellReuseIdentifier: HIEventDetailLocationCell.identifier)
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIProjectDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard project != nil else { return 0 }
        return 1 //Projects have one location
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventDetailLocationCell.identifier, for: indexPath)
//        if let cell = cell as? HIEventDetailLocationCell,
//            let project = project,
//            1 > indexPath.row, //TODO: Projects have one location
//            let location = project.location as? Location { //TODO: Projects have one location
//            cell <- location
//        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIProjectDetailViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let project = project,
//            1 > indexPath.row, //TODO: Projects have one location
//            let location = project.location as? Location { //TODO: Projects have one location
//            let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//            let distance: CLLocationDistance
//            if let userLocation = CLLocationManager().location {
//                distance = userLocation.distance(from: clLocation) * 1.5
//            } else {
//                distance = 1_500
//            }
//
//            let divisor: CLLocationDistance = 50_000
//            let span = MKCoordinateSpan(latitudeDelta: distance/divisor, longitudeDelta: distance/divisor)
//
//            let options = [
//                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: clLocation.coordinate),
//                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: span)
//            ]
//
//            let placemark = MKPlacemark(coordinate: clLocation.coordinate, addressDictionary: nil)
//            let mapItem = MKMapItem(placemark: placemark)
//            mapItem.name = location.name
//            mapItem.openInMaps(launchOptions: options)
//        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

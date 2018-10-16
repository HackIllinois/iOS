//
//  HIEventDetailViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import MapKit

class HIEventDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var event: Event?

    // MARK: Views
    let titleLabel = HILabel(style: .event)
    let descriptionLabel = HILabel(style: .description)
    let favoritedButton = HIButton(style: .iconToggle(activeImage: #imageLiteral(resourceName: "Favorited"), inactiveImage: #imageLiteral(resourceName: "Unfavorited")))

    // MARK: Constraints
    var descriptionLabelHeight = NSLayoutConstraint()
    var tableViewHeight = NSLayoutConstraint()
}

// MARK: - Actions
extension HIEventDetailViewController {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        guard let isFavorite = sender.isActive, let event = event else { return }

        if isFavorite {
            HIEventService.unfavortieBy(id: Int(event.id))
                .onCompletion { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            HILocalNotificationController.shared.unscheduleNotification(for: event)
                            event.favorite = false
                            sender.setToggle(active: event.favorite)
                        }
                    case .cancellation:
                        break
                    case .failure(let error):
                        print(error, error.localizedDescription)
                    }
                }
                .authorization(HIApplicationStateController.shared.user)
                .perform()

        } else {
            HIEventService.favortieBy(id: Int(event.id))
            .onCompletion { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        HILocalNotificationController.shared.scheduleNotification(for: event)
                        event.favorite = true
                        sender.setToggle(active: event.favorite)
                    }
                case .cancellation:
                    break
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
            .authorization(HIApplicationStateController.shared.user)
            .perform()
        }
    }
}

// MARK: - UIViewController
extension HIEventDetailViewController {
    override func loadView() {
        super.loadView()

        let eventDetailContainer = HIView(style: .content)
        eventDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDetailContainer)
        eventDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        eventDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        eventDetailContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        eventDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        let upperContainerView = UIView()
        upperContainerView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(upperContainerView)
        upperContainerView.topAnchor.constraint(equalTo: eventDetailContainer.topAnchor).isActive = true
        upperContainerView.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor).isActive = true
        upperContainerView.trailingAnchor.constraint(equalTo: eventDetailContainer.trailingAnchor).isActive = true
        upperContainerView.heightAnchor.constraint(equalToConstant: 63).isActive = true

        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        upperContainerView.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: upperContainerView.topAnchor).isActive = true
        favoritedButton.leadingAnchor.constraint(equalTo: upperContainerView.leadingAnchor).isActive = true
        favoritedButton.bottomAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true

        titleLabel.textColor = HIApplication.Palette.current.primary
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        upperContainerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: upperContainerView.trailingAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: upperContainerView.centerYAnchor).isActive = true

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = HIApplication.Palette.current.primary
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: eventDetailContainer.trailingAnchor, constant: -12).isActive = true
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true

        let tableView = UITableView()
        tableView.backgroundColor = HIApplication.Palette.current.contentBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: eventDetailContainer.bottomAnchor, constant: -6).isActive = true
        tableView.trailingAnchor.constraint(equalTo: eventDetailContainer.trailingAnchor).isActive = true
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = event else { return }
        titleLabel.text = event.name
        descriptionLabel.text = event.info
        favoritedButton.setToggle(active: event.favorite)
        tableView?.reloadData()
        view.layoutIfNeeded()
        let targetSize = CGSize(width: descriptionLabel.frame.width, height: .greatestFiniteMagnitude)
        let neededSize = descriptionLabel.sizeThatFits(targetSize)
        descriptionLabelHeight.constant = neededSize.height
        tableViewHeight.constant = CGFloat(event.locations.count) * 160
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if event == nil {
            presentErrorController(title: "Error", message: "Failed to load event.", dismissParentOnCompletion: true)
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIEventDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "EVENT DETAILS"
    }
}

// MARK: - UITableView Setup
extension HIEventDetailViewController {
    override func setupTableView() {
        tableView?.alwaysBounceVertical = false
        tableView?.register(HIEventDetailLocationCell.self, forCellReuseIdentifier: HIEventDetailLocationCell.identifier)
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIEventDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let event = event else { return 0 }
        return event.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventDetailLocationCell.identifier, for: indexPath)
        if let cell = cell as? HIEventDetailLocationCell,
            let event = event,
            event.locations.count > indexPath.row,
            let location = event.locations.allObjects[indexPath.row] as? Location {
            cell <- location
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIEventDetailViewController {
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
        if let event = event,
            event.locations.count > indexPath.row,
            let location = event.locations.allObjects[indexPath.row] as? Location {
            let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

            let distance: CLLocationDistance
            if let userLocation = CLLocationManager().location {
                distance = userLocation.distance(from: clLocation) * 1.5
            } else {
                distance = 1_500
            }

            let divisor: CLLocationDistance = 50_000
            let span = MKCoordinateSpan(latitudeDelta: distance/divisor, longitudeDelta: distance/divisor)

            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: clLocation.coordinate),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: span)
            ]

            let placemark = MKPlacemark(coordinate: clLocation.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: options)
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

//
//  HIEventDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
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

class HIEventDetailViewController: HIBaseViewController {
    // MARK: - Properties
    private static let scannerViewController = HIEventScannerViewController()
    var event: Event?

    // MARK: Views
    private let eventDetailContainer = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let upperContainerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let titleLabel = HILabel(style: .event) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentTitle
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
extension HIEventDetailViewController {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        guard let event = event else { return }

        let changeFavoriteStatusRequest: APIRequest<Favorite> =
            sender.isActive ?
                HIAPI.EventService.unfavoriteBy(id: event.id) :
                HIAPI.EventService.favoriteBy(id: event.id)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    sender.isActive.toggle()
                    event.favorite.toggle()
                    event.favorite ?
                        HILocalNotificationController.shared.scheduleNotification(for: event) :
                        HILocalNotificationController.shared.unscheduleNotification(for: event)
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }

    @objc func didSelectScanButton(_ sender: UIBarButtonItem) {
        guard let event = event else { return }
        let now = Date()
        if event.startTime.addingTimeInterval(-15*60) > now {
            let message = "The scanning period for this event has not begun; scanning begins 15 minutes before the event."
            presentErrorController(title: "Sorry", message: message, dismissParentOnCompletion: false)
        } else if now > event.endTime {
            presentErrorController(title: "Sorry", message: "The scanning period for this event has ended.", dismissParentOnCompletion: false)
        } else {
            HIEventDetailViewController.scannerViewController.event = event
            navigationController?.pushViewController(HIEventDetailViewController.scannerViewController, animated: true)
        }
    }
}

// MARK: - UIViewController
extension HIEventDetailViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(eventDetailContainer)
        eventDetailContainer.constrain(to: view.safeAreaLayoutGuide, topInset: 12, trailingInset: -12, leadingInset: 12)
        eventDetailContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true

        eventDetailContainer.addSubview(upperContainerView)
        upperContainerView.constrain(to: eventDetailContainer, topInset: 0, trailingInset: 0, leadingInset: 0)
        upperContainerView.constrain(height: 63)

        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        upperContainerView.addSubview(favoritedButton)
        favoritedButton.constrain(to: upperContainerView, topInset: 0, bottomInset: 0, leadingInset: 0)
        favoritedButton.constrain(width: 58)

        upperContainerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: upperContainerView.trailingAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: upperContainerView.centerYAnchor).isActive = true

        eventDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        descriptionLabel.constrain(to: eventDetailContainer, trailingInset: -12, leadingInset: 12)
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true

        let tableView = UITableView()
        tableView.backgroundColor <- \.contentBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        tableView.constrain(to: eventDetailContainer, trailingInset: 0, bottomInset: -6, leadingInset: 0)
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = event else { return }
        titleLabel.text = event.name
        descriptionLabel.text = event.info
        favoritedButton.isActive = event.favorite

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
            presentErrorController(title: "Uh oh", message: "Failed to load event.", dismissParentOnCompletion: true)
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIEventDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "EVENT DETAILS"
        if let user = HIApplicationStateController.shared.user, !user.roles.intersection([.staff, .admin]).isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didSelectScanButton(_:)))
        }
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

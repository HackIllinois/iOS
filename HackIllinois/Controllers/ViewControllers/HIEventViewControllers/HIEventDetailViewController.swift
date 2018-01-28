//
//  HIEventDetailViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HIEventDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var event: Event?

    // MARK: Views
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let favoritedButton = UIButton()

    // MARK: Constraints
    var descriptionLabelHeight = NSLayoutConstraint()
    var tableViewHeight = NSLayoutConstraint()
}

// MARK: - UIViewController
extension HIEventDetailViewController {
    override func loadView() {
        super.loadView()

        let eventDetailContainer = UIView()
        eventDetailContainer.backgroundColor = HIColor.white
        eventDetailContainer.layer.cornerRadius = 8
        eventDetailContainer.layer.masksToBounds = true
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

        favoritedButton.setImage(#imageLiteral(resourceName: "Unfavorited"), for: .normal)
        favoritedButton.translatesAutoresizingMaskIntoConstraints = false
        upperContainerView.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: upperContainerView.topAnchor).isActive = true
        favoritedButton.leadingAnchor.constraint(equalTo: upperContainerView.leadingAnchor).isActive = true
        favoritedButton.bottomAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 58).isActive = true

        titleLabel.textColor = HIColor.darkIndigo
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        upperContainerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: favoritedButton.trailingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: upperContainerView.trailingAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: upperContainerView.centerYAnchor).isActive = true

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = HIColor.darkIndigo
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: upperContainerView.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: eventDetailContainer.trailingAnchor, constant: -12).isActive = true
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true

        let tableView = UITableView()
        tableView.backgroundColor = HIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: eventDetailContainer.bottomAnchor).isActive = true
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
        tableView?.reloadData()
        view.layoutIfNeeded()
        let targetSize = CGSize(width: descriptionLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let neededSize = descriptionLabel.sizeThatFits(targetSize)
        descriptionLabelHeight.constant = neededSize.height
        tableViewHeight.constant = CGFloat(event.locations.count) * 200 + 6
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
        tableView?.register(HIEventDetailLocationCell.self, forCellReuseIdentifier: HIEventDetailLocationCell.IDENTIFIER)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventDetailLocationCell.IDENTIFIER, for: indexPath)
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
        return 200
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

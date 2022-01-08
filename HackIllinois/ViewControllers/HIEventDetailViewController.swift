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
    var event: Event?

    // MARK: Views
    private let eventDetailContainer = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }
    private let upperContainerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }
    private let titleLabel = HILabel(style: .detailTitle)

    private let sponsorLabel = HILabel(style: .sponsor)
    private let timeLabel = HILabel(style: .description)

    private let descriptionLabel = HILabel(style: .detailText)
    private let favoritedButton = HIButton {
        $0.tintHIColor = \.favoriteStarTint
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }
    private let closeButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "MenuClose")
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
    }

    // MARK: Constraints
    private var descriptionLabelHeight = NSLayoutConstraint()
}

// MARK: - Actions
extension HIEventDetailViewController {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        guard let event = event else { return }

        let changeFavoriteStatusRequest: APIRequest<EventFavorites> =
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

    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIEventDetailViewController {

    override func loadView() {
        super.loadView()

        setupCloseButton()

        view.addSubview(eventDetailContainer)
        eventDetailContainer.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        eventDetailContainer.constrain(to: view.safeAreaLayoutGuide, trailingInset: -8, bottomInset: 0, leadingInset: 8)

        eventDetailContainer.addSubview(upperContainerView)
        upperContainerView.constrain(to: eventDetailContainer, topInset: 25, trailingInset: 0, leadingInset: 0)
        upperContainerView.constrain(height: 75)

        upperContainerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: upperContainerView.topAnchor).isActive = true
        upperContainerView.addSubview(sponsorLabel)
        sponsorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        sponsorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        // Only attendees can favorite events
        if !HIApplicationStateController.shared.isGuest {
            setupFavoritedButton()
        }

        upperContainerView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: sponsorLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        
        eventDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: upperContainerView.bottomAnchor, constant: 30).isActive = true
        descriptionLabel.constrain(to: eventDetailContainer, trailingInset: -12)
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = event else { return }
        titleLabel.text = event.name
        if !event.sponsor.isEmpty {
            sponsorLabel.text = "Sponsored by \(event.sponsor)"
        } else {
            sponsorLabel.text = ""
        }
        descriptionLabel.text = event.info
        timeLabel.text = Formatter.simpleTime.string(from: event.startTime) + " - " + Formatter.simpleTime.string(from: event.endTime)
        favoritedButton.isActive = event.favorite

        view.layoutIfNeeded()
        let targetSize = CGSize(width: descriptionLabel.frame.width, height: .greatestFiniteMagnitude)
        let neededSize = descriptionLabel.sizeThatFits(targetSize)
        descriptionLabelHeight.constant = neededSize.height
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if event == nil {
            presentErrorController(title: "Uh oh", message: "Failed to load event.", dismissParentOnCompletion: true)
        }
    }

    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        closeButton.constrain(height: 20)
    }

    func setupFavoritedButton() {
        view.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        favoritedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        favoritedButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
    }
}

// MARK: - UINavigationItem Setup
extension HIEventDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "EVENT DETAILS"
    }
}

// MARK: - UIImageView Setup
extension HIEventDetailViewController {
    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "EventDetailBackground")
    }
}


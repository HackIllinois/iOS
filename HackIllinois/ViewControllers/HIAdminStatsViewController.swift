//
//  HIAdminStatsViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import HIAPI
import os

class HIAdminStatsViewController: HIBaseViewController {
    private let statsLabel = UITextView()

    private let retrieveStatsButton = HIButton {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = HIAppearance.Font.button
        $0.backgroundHIColor = \.contentBackground
        $0.titleHIColor = \.action
        $0.title = "Retrieve Stats"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        retrieveStatsButton.addTarget(self, action: #selector(didSelectRetrieveStats), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }
}

extension HIAdminStatsViewController {
    override func loadView() {
        super.loadView()

        // Create Retrieve Stats Button
        view.addSubview(retrieveStatsButton)
        retrieveStatsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        retrieveStatsButton.constrain(to: view.safeAreaLayoutGuide, trailingInset: -20, leadingInset: 20)
        retrieveStatsButton.constrain(height: 50)

        // Stats JSON View
        view.addSubview(statsLabel)
        statsLabel.isEditable = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.font = HIAppearance.Font.contentText
        statsLabel.backgroundColor = UIColor.white
        statsLabel.isScrollEnabled = true
        statsLabel.topAnchor.constraint(equalTo: retrieveStatsButton.bottomAnchor, constant: 15).isActive = true
        statsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        statsLabel.constrain(to: view.safeAreaLayoutGuide, trailingInset: -20, leadingInset: 20)
    }
}

// MARK: - UINavigationItem Setup
extension HIAdminStatsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "STATS"
    }
}

extension HIAdminStatsViewController {
    @objc func didSelectRetrieveStats() {
        HIAPI.StatsService.getStats()
            .onCompletion { [weak self] result in
                do {
                    let (apiStatsString, _) = try result.get()
                    DispatchQueue.main.async {
                        self?.statsLabel.text = apiStatsString
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.statsLabel.text = ""
                    }
                    os_log(
                        "Error retrieving stats",
                        log: Logger.ui,
                        type: .error
                    )
                }
            }
            .authorize(with: HIApplicationStateController.shared.user)
            .launch()
    }
}

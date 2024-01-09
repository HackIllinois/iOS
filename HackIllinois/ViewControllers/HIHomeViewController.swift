//
//  HIHomeViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import PassKit
import os
import HIAPI

class HIHomeViewController: HIEventListViewController {
    // MARK: - Properties
    private lazy var countdownViewController = HICountdownViewController(delegate: self)
    private lazy var bannerViewController = HIBannerViewController()
    private let countdownFrameView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let bannerFrameView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var isLegendButtonSelected = false
    private let legendButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "Question Mark")
        $0.activeImage = #imageLiteral(resourceName: "Question Mark Toggled")
    }
    
    private var timer: Timer?

    private var countdownDataStoreIndex = 0
    private var staticDataStore: [(date: Date, displayText: String)] = [
        (HITimeDataSource.shared.eventTimes.eventStart, "HACKILLINOIS BEGINS IN"),
        (HITimeDataSource.shared.eventTimes.hackStart, "HACKING BEGINS IN"),
        (HITimeDataSource.shared.eventTimes.hackEnd, "HACKING ENDS IN"),
        (HITimeDataSource.shared.eventTimes.eventEnd, "HACKILLINOIS ENDS IN")
    ]

    var transparentImageView: UIImageView!
}

// MARK: - UIViewController
extension HIHomeViewController {
    override func loadView() {
        super.loadView()
        setUpBanner()
        setUpCountdown()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        
        // Initialize the UIImageView
        transparentImageView = UIImageView(frame: view.bounds)
        transparentImageView.contentMode = .scaleAspectFill
        transparentImageView.alpha = 0
        transparentImageView.image = UIImage(named: "Home_Tags_Transparent")

        // Add the UIImageView to your view hierarchy
        view.addSubview(transparentImageView)
        view.bringSubviewToFront(transparentImageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countdownViewController.startUpCountdown()
        layoutLegendButton()
        setupPredicateRefreshTimer()
        setupPass()
    }
    
    func layoutLegendButton() {
        view.addSubview(legendButton)
        
        legendButton.constrain(width: 25, height: 25)
        legendButton.addTarget(self, action: #selector(didSelectLegendButton(_:)), for: .touchUpInside)
        
        legendButton.topAnchor.constraint(equalTo: bannerFrameView.topAnchor).isActive = true
        legendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
    
    func setUpCountdown() {
        view.addSubview(countdownFrameView)
        countdownFrameView.translatesAutoresizingMaskIntoConstraints = false
        var countdownFrameConstant: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            countdownFrameConstant = 1.7
        } else if UIScreen.main.bounds.width < 375.0 {
            countdownFrameConstant = 0.9
        }
        countdownFrameView.topAnchor.constraint(equalTo: bannerFrameView.bottomAnchor, constant: 7.5).isActive = true
        countdownFrameView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        let widthConstant: CGFloat = 329 * countdownFrameConstant
        let heightConstant: CGFloat = 263 * countdownFrameConstant
        countdownFrameView.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        countdownFrameView.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        countdownFrameView.addSubview(countdownViewController.view)
        countdownViewController.view.translatesAutoresizingMaskIntoConstraints = false
        countdownViewController.view.topAnchor.constraint(equalTo: countdownFrameView.topAnchor).isActive = true
        countdownViewController.view.heightAnchor.constraint(equalTo: countdownFrameView.heightAnchor, multiplier: 0.3).isActive = true
        countdownViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        countdownViewController.didMove(toParent: self)
        
        bannerViewController.view.widthAnchor.constraint(equalTo: countdownViewController.view.widthAnchor).isActive = true
    }
    func setUpBanner() {
        view.addSubview(bannerFrameView)
        bannerFrameView.translatesAutoresizingMaskIntoConstraints = false
        bannerFrameView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bannerFrameView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        bannerFrameView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        var bannerFrameConstant: CGFloat = 1.0
        var bannerFrameTopAnchorConstant: CGFloat = 1.0
        var bannerFrameHeightConstant: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            bannerFrameConstant = -0.5
            bannerFrameTopAnchorConstant = 1.9
            bannerFrameHeightConstant = 1.2
        } else if UIScreen.main.bounds.width < 375.0 {
            bannerFrameConstant = 0.9
            bannerFrameTopAnchorConstant = 0.9
            bannerFrameHeightConstant = 0.9
        }
        bannerFrameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50 * bannerFrameTopAnchorConstant).isActive = true
        //let widthConstant: CGFloat = 290
        let heightConstant: CGFloat = 20 * bannerFrameHeightConstant
        //bannerFrameView.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        bannerFrameView.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        bannerFrameView.addSubview(bannerViewController.view)
        bannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bannerViewController.view.topAnchor.constraint(equalTo: bannerFrameView.topAnchor).isActive = true
        bannerViewController.view.heightAnchor.constraint(equalTo: bannerFrameView.heightAnchor).isActive = true
        bannerViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        bannerViewController.didMove(toParent: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        teardownPredicateRefreshTimer()
    }
}

// MARK: - UIImageView Setup
extension HIHomeViewController {
    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        
        let now = Date()
        let checkInStart = HITimeDataSource.shared.eventTimes.checkInStart
        let checkInEnd = HITimeDataSource.shared.eventTimes.checkInEnd
        let scavengerHuntEnd = HITimeDataSource.shared.eventTimes.scavengerHuntEnd
        let openingCeremonyEnd = HITimeDataSource.shared.eventTimes.openingCeremonyEnd
        let hackEnd = HITimeDataSource.shared.eventTimes.hackEnd
        let projectShowcaseEnd = HITimeDataSource.shared.eventTimes.projectShowcaseEnd
        let closingCeremonyEnd = HITimeDataSource.shared.eventTimes.closingCeremonyEnd
        
        if now < checkInStart {
            backgroundView.image = #imageLiteral(resourceName: "Home_Start")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_Start")
            }
        } else if now < checkInEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_1")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_1")
            }
        } else if now < scavengerHuntEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_2")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_2")
            }
        } else if now < openingCeremonyEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_3")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_3")
            }
        } else if now < hackEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_4")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_4")
            }
        } else if now < projectShowcaseEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_5")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_5")
            }
        } else if now < closingCeremonyEnd {
            backgroundView.image = #imageLiteral(resourceName: "Home_6")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_6")
            }
        } else {
            backgroundView.image = #imageLiteral(resourceName: "Home_Final")
            if UIDevice.current.userInterfaceIdiom == .pad {
                backgroundView.image = #imageLiteral(resourceName: "Home_Final")
            }
        }
    }
}

// MARK: - UITabBarItem Setup
extension HIHomeViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "HomeSelected"))
    }
}

// MARK: - Actions
extension HIHomeViewController: HICountdownViewControllerDelegate {
    func countdownToDateFor(countdownViewController: HICountdownViewController) -> Date? {
        let now = Date()
        while countdownDataStoreIndex < staticDataStore.count {
            let currDate = staticDataStore[countdownDataStoreIndex].date
            let displayText = staticDataStore[countdownDataStoreIndex].displayText
            if currDate > now {
                // Displays before and during the event
//                super.setCustomTitle(customTitle: displayText)
                bannerViewController.updateLabel(with: displayText)
                return currDate
            } else {
                // Displays after the event ends
//                super.setCustomTitle(customTitle: "MEMORIES MADE")
                bannerViewController.updateLabel(with: "MEMORIES MADE")
            }
            countdownDataStoreIndex += 1
        }
        return nil
    }
}

extension HIHomeViewController {
    @objc func didSelectLegendButton(_ sender: UIButton) {
        isLegendButtonSelected.toggle()
        
        if isLegendButtonSelected {
            legendButton.isActive = true
        } else {
            legendButton.isActive = false
        }
        

        UIView.animate(withDuration: 0.5) {
            self.transparentImageView.alpha = self.transparentImageView.alpha == 0 ? 1 : 0
        }
    }
}

// MARK: - Pass/Wallet setup
extension HIHomeViewController {
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
            let user = HIApplicationStateController.shared.user,
            !HIApplicationStateController.shared.isGuest,
            let url = user.qrURL,
            !UserDefaults.standard.bool(forKey: HIConstants.PASS_PROMPTED_KEY(user: user)) else { return }
        HIAPI.PassService.getPass(qr: url.absoluteString, identifier: user.email)
        .onCompletion { result in
            do {
                let (data, _) = try result.get()
                let pass = try PKPass(data: data)
                guard let passVC = PKAddPassesViewController(pass: pass) else {
                    throw HIError.passbookError
                }
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        UserDefaults.standard.set(true, forKey: HIConstants.PASS_PROMPTED_KEY(user: user))
                        strongSelf.present(passVC, animated: true, completion: nil)
                    }
                }
            } catch {
                os_log(
                    "Error initializing PKPass: %s",
                    log: Logger.ui,
                    type: .error,
                    String(describing: error)
                )
            }
        }
        .launch()
    }
}

extension HIHomeViewController {
    func setupPredicateRefreshTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 60, // Updates every minute
            target: self,
            selector: #selector(refreshPredicate),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func refreshPredicate() {
        setUpBackgroundView()
    }

    func teardownPredicateRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }
}

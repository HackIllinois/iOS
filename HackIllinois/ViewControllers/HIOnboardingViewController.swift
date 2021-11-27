//
//  HIOnboardingViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.


import Foundation

import UIKit

class HIOnboardingViewController: HIBaseViewController {    
    //source: https://medium.com/swlh/swift-carousel-759800aa2952
    // MARK: - Subviews
    
    private var carouselView: HICarouselView?
    
    // MARK: - Properties
    
    private var carouselData = [HICarouselView.CarouselData]()
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1215686275, green: 0.5176470588, blue: 0.6470588235, alpha: 1), #colorLiteral(red: 1, green: 0.4666666667, blue: 0.4352941176, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.5490196078, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.5490196078, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.5490196078, blue: 0.7568627451, alpha: 1)]
    
    let getStartedButton = HIButton {
        $0.title = "Get Started"
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = HIAppearance.Font.onboardingGetStartedText
        $0.backgroundHIColor = \.buttonViewBackground
        $0.titleHIColor = \.action
        $0.title = "Get Started"
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = .zero
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
    }
    
    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "Login")
    }
}

extension HIOnboardingViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        carouselView = HICarouselView(pages: 5, delegate: self)
        carouselData.append(.init(image: UIImage(named: "HILogo"), titleText: "", descriptionText: "Swipe to see what our app has to offer!"))
        carouselData.append(.init(image: UIImage(named: "Day"), titleText: "Check-In",descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        carouselData.append(.init(image: UIImage(named: "ProfileBackground"), titleText: "Scan for Points", descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        carouselData.append(.init(image: UIImage(named: "ProfileBackground"), titleText: "Get Notified", descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        carouselData.append(.init(image: UIImage(named: "ProfileBackground"), titleText: "Win Prizes", descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: carouselData)
    }
}

// MARK: - Setups

private extension HIOnboardingViewController {
    func setupUI() {
        view.backgroundColor = backgroundColors.first
        
        getStartedButton.addTarget(self, action: #selector(didSelectGetStarted(_:)), for: .touchUpInside)
        view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getStartedButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor).isActive = true
    }
}

// MARK: - CarouselViewDelegate

extension HIOnboardingViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        // Used for changing the background color based on the carousel page
//        UIView.animate(withDuration: 0.7) {
//            self.view.backgroundColor = self.backgroundColors[page]
//        }
    }
}

extension HIOnboardingViewController {
    @objc func didSelectGetStarted(_ sender: HIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .getStarted, object: nil)
        }
    }
}

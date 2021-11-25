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

class HIOnboardingViewController: UIViewController {
    //source: https://medium.com/swlh/swift-carousel-759800aa2952
    // MARK: - Subvies
    
    private var carouselView: HICarouselView?
    
    // MARK: - Properties
    
    private var carouselData = [HICarouselView.CarouselData]()
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView = HICarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "AppIcon"), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        carouselData.append(.init(image: UIImage(named: "Day"), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        carouselData.append(.init(image: UIImage(named: "DefaultProfilePicture"), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        
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
        
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - CarouselViewDelegate

extension HIOnboardingViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.7) {
            self.view.backgroundColor = self.backgroundColors[page]
        }
    }
}

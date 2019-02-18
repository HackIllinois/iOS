//
//  HIIndoorMapsViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIIndoorMapsViewController: HIBaseViewController {
    // MARK: - Properties
    private let topSegmentedControl = HISegmentedControl(items: HIMapsDataSource.shared.maps.map { $0.name })
    private let bottomSegmentedControl = HISegmentedControl(items: HIMapsDataSource.shared.maps[0].floors.map { $0.name })

    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.accent
    }
    private let scrollView = UIScrollView(frame: .zero)
    private let mapImageView = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.5176470588, blue: 0.6470588235, alpha: 1)
    }
}

// MARK: - Actions
extension HIIndoorMapsViewController {
    @objc func didSelectSegmentedControl(_ sender: HISegmentedControl) {
        let map = HIMapsDataSource.shared.maps[topSegmentedControl.selectedIndex]
        if sender === topSegmentedControl {
            bottomSegmentedControl.update(items: map.floors.map { $0.name })
        }

        let floor = map.floors[0]
        mapImageView.image = floor.image
    }
}

// MARK: - UIViewController
extension HIIndoorMapsViewController {
    override func loadView() {
        super.loadView()

        topSegmentedControl.addTarget(self, action: #selector(didSelectSegmentedControl(_:)), for: .valueChanged)
        bottomSegmentedControl.addTarget(self, action: #selector(didSelectSegmentedControl(_:)), for: .valueChanged)

        // Segmented Control Setup
        view.addSubview(topSegmentedControl)
        topSegmentedControl.constrain(to: view.safeAreaLayoutGuide, topInset: 0, trailingInset: -12, leadingInset: 12)
        topSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true

        view.addSubview(bottomSegmentedControl)
        bottomSegmentedControl.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor).isActive = true
        bottomSegmentedControl.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        bottomSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 24).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomSegmentedControl.topAnchor, constant: -24).isActive = true

        // MapImageView setup
        scrollView.backgroundColor = .red
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 5.0
        scrollView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//        view.addSubview(scrollView)
//        scrollView.topAnchor.constraint(equalTo: bottomSegmentedControl.bottomAnchor, constant: 24).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true

//        scrollView.addSubview(mapImageView)
//
////        mapImageView.image = indoorMaps[currentTab].floors[currentFloor].image
//        mapImageView.contentMode = .scaleAspectFit
//
//        mapImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
//        mapImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24).isActive = true
//        mapImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24).isActive = true
//        mapImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = scrollView.frame.size
    }
}

// MARK: - UINavigationItem Setup
extension HIIndoorMapsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "INDOOR MAPS"
    }
}

//
//  HIIndoorMapsViewController.swift
//  HackIllinois
//
//  Created by Alex Drewno on 2/6/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIIndoorMapsViewController: HIBaseViewController {
    //MARK:- Properties
    var currentTab = 0
    let mapImageView = HIImageView(style: .template)
    var indoorMaps: [(name: String, image: UIImage)] = {
        var indoorMaps = [(name: String, image: UIImage)]()
        let dclImage = UIImage()
        indoorMaps.append((name: "DCL", image: dclImage))
        
        let siebelImage = UIImage()
        indoorMaps.append((name: "Siebel", image: siebelImage))
        
        let ecebImage = UIImage()
        indoorMaps.append((name: "ECEB", image: ecebImage))
        
        let unionImage = UIImage()
        indoorMaps.append((name: "Union", image: unionImage))
        
        return indoorMaps
    }()
}

// MARK: - Actions
extension HIIndoorMapsViewController {
    @objc func didSelectTab(_ sender: HISegmentedControl) {
        currentTab = sender.selectedIndex
    }
}

// MARK: - UIViewController
extension HIIndoorMapsViewController {
    override func loadView() {
        super.loadView()
        
        let items = indoorMaps.map { $0.name }
        let segmentedControl = HISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        view.addSubview(mapImageView)
        mapImageView.image = indoorMaps[currentTab].image
        mapImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24).isActive = true
        mapImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        mapImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        mapImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        mapImageView.backgroundColor = UIColor.black
    }
}

// MARK: - UINavigationItem Setup
extension HIIndoorMapsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "INDOOR MAPS"
    }
}

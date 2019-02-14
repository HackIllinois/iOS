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
    var currentTab = 0
    var currentFloor = 0
    var bottomSegmentedControl: HISegmentedControl!

    let mapImageView = HIImageView {
        $0.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.5176470588, blue: 0.6470588235, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var indoorMaps: [(name: String, floors: [(floorName: String, image: UIImage)])] = {
        var indoorMaps = [(name: String, floors: [(floorName: String, image: UIImage)])]()

        //Siebel Maps
        var siebelFloors = [(floorName: String, image: UIImage)]()
        var siebelFloor1 = UIImage(named: "IndoorMapSiebel1") ?? UIImage()
        var siebelFloor2 = UIImage(named: "IndoorMapSiebel2") ?? UIImage()
        var siebelFloor3 = UIImage(named: "IndoorMapSiebel3") ?? UIImage()
        siebelFloors.append((floorName: "Basement", image: siebelFloor1))
        siebelFloors.append((floorName: "1st Floor", image: siebelFloor2))
        siebelFloors.append((floorName: "2nd Floor", image: siebelFloor3))
        indoorMaps.append((name: "Siebel", floors: siebelFloors))

        //ECEB Maps
        var ecebFloors = [(floorName: String, image: UIImage)]()
        var ecebImage1 = UIImage(named: "IndoorMapECEB1") ?? UIImage()
        var ecebImage2 = UIImage(named: "IndoorMapECEB2") ?? UIImage()
        var ecebImage3 = UIImage(named: "IndoorMapECEB3") ?? UIImage()
        ecebFloors.append((floorName: "1st Floor", image: ecebImage1))
        ecebFloors.append((floorName: "2nd Floor", image: ecebImage2))
        ecebFloors.append((floorName: "3rd Floor", image: ecebImage3))
        indoorMaps.append((name: "ECEB", floors: ecebFloors))

        //DCL Maps
        var dclFloors = [(floorName: String, image: UIImage)]()
        var dclImage = UIImage(named: "IndoorMapDCL") ?? UIImage()
        dclFloors.append((floorName: "1st Floor", image: dclImage))
        indoorMaps.append((name: "DCL", floors: dclFloors))

        //Kenney Maps
        var kenneyFloors = [(floorName: String, image: UIImage)]()
        var kenneyImage = UIImage(named: "IndoorMapKenney") ?? UIImage()
        kenneyFloors.append((floorName: "1st Floor", image: kenneyImage))
        indoorMaps.append((name: "Kenney", floors: kenneyFloors))
        return indoorMaps
    }()

}

// MARK: - Actions
extension HIIndoorMapsViewController {
    @objc func didSelectMap(_ sender: HISegmentedControl) {
        currentTab = sender.selectedIndex
        currentFloor = 0
        mapImageView.image = indoorMaps[currentTab].floors[currentFloor].image
        updateBottomSegmentedControl()
    }

    @objc func didSelectFloor(_ sender: HISegmentedControl) {
        currentFloor = sender.selectedIndex
        mapImageView.image = indoorMaps[currentTab].floors[currentFloor].image
    }

    func updateBottomSegmentedControl() {
        let bottomItems = indoorMaps[currentTab].floors.map { $0.floorName }
        loadBottomSegmentedControl(with: bottomItems)
    }
}

// MARK: - UIViewController
extension HIIndoorMapsViewController {
    override func loadView() {
        super.loadView()

        //Segmented Control Setup
        let items = indoorMaps.map { $0.name }
        let segmentedControl = HISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(didSelectMap(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        updateBottomSegmentedControl()

        //MapImageView setup
        view.addSubview(mapImageView)
        mapImageView.image = indoorMaps[currentTab].floors[currentFloor].image
        mapImageView.contentMode = .scaleAspectFit
        mapImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24).isActive = true
        mapImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        mapImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        mapImageView.bottomAnchor.constraint(equalTo: bottomSegmentedControl.topAnchor, constant: -24).isActive = true
    }

    func loadBottomSegmentedControl(with items: [String]) {
        bottomSegmentedControl = HISegmentedControl(items: items)
        bottomSegmentedControl.addTarget(self, action: #selector(didSelectFloor(_:)), for: .valueChanged)
        bottomSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSegmentedControl)
        bottomSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        bottomSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        bottomSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        bottomSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
}

// MARK: - UINavigationItem Setup
extension HIIndoorMapsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "INDOOR MAPS"
    }
}

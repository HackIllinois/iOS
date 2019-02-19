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
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.mapBackground
    }
    private let scrollView = UIScrollView(frame: .zero)
    private let mapImageView = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Actions
extension HIIndoorMapsViewController {
    @objc func didSelectSegmentedControl(_ sender: HISegmentedControl) {
        let map = HIMapsDataSource.shared.maps[topSegmentedControl.selectedIndex]
        if sender === topSegmentedControl {
            bottomSegmentedControl.update(items: map.floors.map { $0.name })
        }

        let floor = map.floors[bottomSegmentedControl.selectedIndex]
        mapImageView.image = floor.image
        setZoomScale()
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
        topSegmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)

        view.addSubview(bottomSegmentedControl)
        bottomSegmentedControl.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor).isActive = true
        bottomSegmentedControl.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        bottomSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        topSegmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)

        // MapImageView setup
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: bottomSegmentedControl.bottomAnchor, constant: 12).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true

        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = 5.0
        contentView.addSubview(scrollView)
        scrollView.constrain(to: contentView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        mapImageView.image = HIMapsDataSource.shared.maps[0].floors[0].image
        mapImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(mapImageView)
        mapImageView.constrain(to: scrollView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = scrollView.frame.size
    }

    func setZoomScale() {
        if let image = mapImageView.image {
            let imageViewSize = image.size
            let scrollViewSize = scrollView.bounds.size
            let widthScale = scrollViewSize.width / imageViewSize.width
            let heightScale = scrollViewSize.height / imageViewSize.height
            let minZoomScale = min(widthScale, heightScale)
            scrollView.minimumZoomScale = minZoomScale
            scrollView.zoomScale = minZoomScale
            mapImageView.center = scrollView.center
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setZoomScale()
    }
}

// MARK: UIScrollViewDelegate
extension HIIndoorMapsViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
}

// MARK: - UINavigationItem Setup
extension HIIndoorMapsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "INDOOR MAPS"
    }
}

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
    private let mapImageView = UIImageView()
    private var observation: NSKeyValueObservation?
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
        topSegmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topSegmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)

        view.addSubview(bottomSegmentedControl)
        bottomSegmentedControl.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor).isActive = true
        bottomSegmentedControl.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        bottomSegmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topSegmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)

        // MapImageView setup
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: bottomSegmentedControl.bottomAnchor, constant: 12).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        scrollView.constrain(to: contentView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        scrollView.addSubview(mapImageView)
        didSelectSegmentedControl(bottomSegmentedControl)
    }

    func setZoomScale() {
        mapImageView.sizeToFit()
        scrollView.contentOffset = .zero
        let widthScale = scrollView.bounds.width / mapImageView.bounds.width
        let heightScale = scrollView.bounds.height / mapImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        let maxScale = max(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        scrollView.zoomScale = minScale
        mapImageView.center = scrollView.center
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setZoomScale()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observation = mapImageView.observe(\.bounds) { [weak scrollView] (mapImageView, _) in
            scrollView?.contentSize = mapImageView.bounds.size
        }
        setZoomScale()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observation?.invalidate()
        observation = nil
    }
}

// MARK: UIScrollViewDelegate
extension HIIndoorMapsViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        // adjust the center of image view
        mapImageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }

    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIIndoorMapsViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "INDOOR MAPS"
    }
}

// MARK: - UITabBarItem Setup
extension HIIndoorMapsViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "map"), tag: 0)
    }
}

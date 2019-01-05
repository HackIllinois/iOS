//
//  HIEventDetailLocationCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/26/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import MapKit

class HIEventDetailLocationCell: UITableViewCell {

    // MARK: - Properties
    var animator: UIViewPropertyAnimator?

    // MARK: Views
    let mapView = MKMapView()
    let mapAnnotation = MKPointAnnotation()
    let titleLabel = HILabel(style: .location)

    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let containerView = UIView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = HIAppearance.current.background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.constrain(to: contentView, topInset: 6, trailingInset: -12, bottomInset: -6, leadingInset: 12)

        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mapView)
        mapView.constrain(to: containerView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurEffectView)
        blurEffectView.constrain(to: containerView, topInset: 0, trailingInset: 0, leadingInset: 0)
        blurEffectView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.textColor = HIAppearance.current.primary
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.constrain(to: blurEffectView.contentView, topInset: 0, bottomInset: 0)

        let disclosureIndicatorImageView = HIImageView(style: .icon(image: #imageLiteral(resourceName: "DisclosureIndicator")))
        blurEffectView.contentView.addSubview(disclosureIndicatorImageView)
        disclosureIndicatorImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        disclosureIndicatorImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        disclosureIndicatorImageView.constrain(to: blurEffectView.contentView, topInset: 0, trailingInset: 0, bottomInset: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        contentView.backgroundColor = HIAppearance.current.contentBackground
        blurEffectView.backgroundColor = HIAppearance.current.frostedTint
    }
}

// MARK: - UITableViewCell
extension HIEventDetailLocationCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mapView.removeAnnotation(mapAnnotation)
        mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setActive(highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setHighlighted(selected, animated: animated)
        setActive(selected)
    }

    func setActive(_ active: Bool) {
        let finalAlpha: CGFloat = active ? 0.5 : 1.0
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator?.addAnimations { [weak self] in
            self?.containerView.alpha = finalAlpha
        }
        animator?.startAnimation()
    }
}

// MARK: - Population
extension HIEventDetailLocationCell {
    static func <- (lhs: HIEventDetailLocationCell, rhs: Location) {
        lhs.titleLabel.text = rhs.name
        let clLocation = CLLocation(latitude: rhs.latitude, longitude: rhs.longitude)

        let distance: CLLocationDistance = 150

        let region = MKCoordinateRegion.init(center: clLocation.coordinate, latitudinalMeters: distance * 2, longitudinalMeters: distance)
        let topLeft = CLLocationCoordinate2D(
            latitude: region.center.latitude + (region.span.latitudeDelta / 2),
            longitude: region.center.longitude - (region.span.longitudeDelta / 2)
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: region.center.latitude - (region.span.latitudeDelta / 2),
            longitude: region.center.longitude + (region.span.longitudeDelta / 2)
        )

        let topLeftPoint = MKMapPoint(topLeft)
        let bottomoRightPoint = MKMapPoint(bottomRight)

        let rect = MKMapRect(
            origin: MKMapPoint(x: min(topLeftPoint.x, bottomoRightPoint.x), y: min(topLeftPoint.y, bottomoRightPoint.y)),
            size: MKMapSize(width: abs(topLeftPoint.x - bottomoRightPoint.x), height: abs(topLeftPoint.y - bottomoRightPoint.y))
        )

        lhs.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), animated: false)

        lhs.mapAnnotation.coordinate = clLocation.coordinate
        lhs.mapView.addAnnotation(lhs.mapAnnotation)
    }
}

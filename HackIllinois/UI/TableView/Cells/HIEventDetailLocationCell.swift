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
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = HIApplication.Palette.current.background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        HIConstraints.setConstraintsWithOffsetFromView(constraintedView: containerView, equalToView: contentView, setTop: true, setBottom: true, setWidth: false, setHeight: false, setLeading: true, setTrailing: true, topConstant: 6, bottomConstant: -6, widthConstant: 0, heightConstant: 0, leadingConstant: 12, trailingConstant: -12)
        

        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mapView)
        HIConstraints.setConstraints(constraintedView: mapView, equalToView: containerView, setTop: true, setBottom: true, setWidth: false, setHeight: false, setLeading: true, setTrailing: true)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurEffectView)
        HIConstraints.setConstraints(constraintedView: blurEffectView, equalToView: containerView, setTop: true, setBottom: false, setWidth: false, setHeight: false, setLeading: true, setTrailing: true)
        blurEffectView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.textColor = HIApplication.Palette.current.primary
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8).isActive = true
        HIConstraints.setConstraints(constraintedView: titleLabel, equalToView: blurEffectView.contentView, setTop: true, setBottom: true, setWidth: false, setHeight: false, setLeading: false, setTrailing: false)

        let disclosureIndicatorImageView = HIImageView(style: .icon(image: #imageLiteral(resourceName: "DisclosureIndicator")))
        blurEffectView.contentView.addSubview(disclosureIndicatorImageView)
        disclosureIndicatorImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        disclosureIndicatorImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        HIConstraints.setConstraints(constraintedView: disclosureIndicatorImageView, equalToView: blurEffectView.contentView, setTop: true, setBottom: true, setWidth: false, setHeight: false, setLeading: false, setTrailing: true)

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
        contentView.backgroundColor = HIApplication.Palette.current.contentBackground
        switch HIApplication.Theme.current {
        case .day:
            blurEffectView.backgroundColor = nil
        case .night:
            blurEffectView.backgroundColor = HIApplication.Palette.current.contentBackground.withAlphaComponent(0.7)
        }
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

        let region = MKCoordinateRegionMakeWithDistance(clLocation.coordinate, distance * 2, distance)
        let topLeft = CLLocationCoordinate2D(
            latitude: region.center.latitude + (region.span.latitudeDelta / 2),
            longitude: region.center.longitude - (region.span.longitudeDelta / 2)
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: region.center.latitude - (region.span.latitudeDelta / 2),
            longitude: region.center.longitude + (region.span.longitudeDelta / 2)
        )

        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)

        let rect = MKMapRect(
            origin: MKMapPoint(x: min(a.x, b.x), y: min(a.y, b.y)),
            size: MKMapSize(width: abs(a.x - b.x), height: abs(a.y - b.y))
        )

        lhs.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), animated: false)

        lhs.mapAnnotation.coordinate = clLocation.coordinate
        lhs.mapView.addAnnotation(lhs.mapAnnotation)
    }
}

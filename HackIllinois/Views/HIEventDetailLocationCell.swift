//
//  HIEventDetailLocationCell.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/26/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HIEventDetailLocationCell: HIBaseTableViewCell {
    // MARK: - Properties
    var selectedEffect: UIBlurEffect {
        return UIBlurEffect(style: .extraLight)
    }

    var highlightedEffect: UIBlurEffect {
        return UIBlurEffect(style: .extraLight)
    }

    var defaultEffect: UIBlurEffect {
        return UIBlurEffect(style: .light)
    }

    // MARK: Views
    let mapView = MKMapView()
    let mapAnnotation = MKPointAnnotation()
    let titleLabel = UILabel()

    lazy var blurEffectView = UIVisualEffectView(effect: defaultEffect)

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = HIApplication.Color.white
        containerView = UIView()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = HIApplication.Color.paleBlue
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        blurEffectView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.textColor = HIApplication.Color.darkIndigo
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor).isActive = true

        let disclosureIndicatorImageView = UIImageView(image: #imageLiteral(resourceName: "DisclosureIndicator"))
        disclosureIndicatorImageView.contentMode = .center
        disclosureIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(disclosureIndicatorImageView)
        disclosureIndicatorImageView.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor).isActive = true
        disclosureIndicatorImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        disclosureIndicatorImageView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor).isActive = true
        disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        disclosureIndicatorImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
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
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.blurEffectView.effect = highlighted ? self.highlightedEffect : self.defaultEffect
        }
        animator.startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let duration = animated ? 0.2 : 0
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator.addAnimations {
            self.blurEffectView.effect = selected ? self.selectedEffect : self.defaultEffect
        }
        animator.startAnimation()
    }
}

// MARK: - Population
extension HIEventDetailLocationCell {
    static func <- (lhs: HIEventDetailLocationCell, rhs: Location) {
        lhs.titleLabel.text = rhs.name
        let clLocation = CLLocation(latitude: rhs.latitude, longitude: rhs.longitude)

        let distance: CLLocationDistance
        if let userLocation = CLLocationManager().location {
            distance = userLocation.distance(from: clLocation)
        } else {
            distance = 1000
        }

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

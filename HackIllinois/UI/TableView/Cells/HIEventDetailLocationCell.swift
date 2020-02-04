//
//  HIEventDetailLocationCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/26/18.
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
    let titleLabel = HILabel(style: .location) {
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentSubtitle
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let containerView = UIView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.3607843137, alpha: 0.3984650088)
        contentView.layer.shadowOffset = CGSize(width: 1, height: 3)
        contentView.layer.shadowOpacity = 1.0

        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor <- \.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true

        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mapView)
        mapView.constrain(to: containerView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurEffectView)
        blurEffectView.constrain(to: containerView, topInset: 0, trailingInset: 0, leadingInset: 0)
        blurEffectView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.constrain(to: blurEffectView.contentView, topInset: 0, bottomInset: 0)

        let disclosureIndicatorImageView = HITintImageView {
            $0.tintHIColor = \.accent
            $0.contentMode = .center
            $0.image = #imageLiteral(resourceName: "DisclosureIndicator")
        }
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
        contentView.backgroundColor <- \.contentBackground
        blurEffectView.backgroundColor <- \.frostedTint
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
        lhs.backgroundColor = UIColor.clear
        lhs.contentView.layer.backgroundColor = UIColor.clear.cgColor
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

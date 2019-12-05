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
        containerView.backgroundColor <- \.baseBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.constrain(to: contentView, topInset: 6, trailingInset: -12, bottomInset: -6, leadingInset: 12)

        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mapView)
        mapView.constrain(to: containerView, topInset: 0, trailingInset: 0, leadingInset: 0)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.layer.backgroundColor = UIColor.white.cgColor
        containerView.addSubview(blurEffectView)
        blurEffectView.constrain(to: containerView, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        blurEffectView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        blurEffectView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        configureDisclosureIndicatorView()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    func configureDisclosureIndicatorView() {
        let disclosureIndicatorStackView = UIStackView()
        disclosureIndicatorStackView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(disclosureIndicatorStackView)
        blurEffectView.contentView.bottomAnchor.constraint(equalTo: disclosureIndicatorStackView.bottomAnchor, constant: 14).isActive = true
        disclosureIndicatorStackView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: 2).isActive = true
        disclosureIndicatorStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        disclosureIndicatorStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let disclosureIndicatorLabel = HILabel(style: .event) {
            $0.textColor <- \.baseText
            $0.font = HIAppearance.Font.contentTitle
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        disclosureIndicatorLabel.text = "GET DIRECTIONS"

        let disclosureIndicatorImageView = HITintImageView {
            $0.tintHIColor = \.transparentBackground
            $0.contentMode = .left
            $0.image = #imageLiteral(resourceName: "DisclosureIndicator")
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        disclosureIndicatorStackView.addSubview(disclosureIndicatorLabel)
        disclosureIndicatorStackView.addSubview(disclosureIndicatorImageView)
        disclosureIndicatorLabel.widthAnchor.constraint(equalTo: disclosureIndicatorStackView.widthAnchor, multiplier: 0.8).isActive = true
        disclosureIndicatorLabel.trailingAnchor.constraint(equalTo: disclosureIndicatorImageView.leadingAnchor, constant: 4).isActive = true
        disclosureIndicatorLabel.leadingAnchor.constraint(equalTo: disclosureIndicatorStackView.leadingAnchor, constant: 0).isActive = true
        disclosureIndicatorLabel.topAnchor.constraint(equalTo: disclosureIndicatorStackView.topAnchor, constant: 0).isActive = true
        disclosureIndicatorLabel.bottomAnchor.constraint(equalTo: disclosureIndicatorStackView.bottomAnchor, constant: 0).isActive = true
        disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: disclosureIndicatorStackView.trailingAnchor, constant: 0).isActive = true
        disclosureIndicatorImageView.topAnchor.constraint(equalTo: disclosureIndicatorStackView.topAnchor, constant: 0).isActive = true
        disclosureIndicatorImageView.bottomAnchor.constraint(equalTo: disclosureIndicatorStackView.bottomAnchor, constant: 0).isActive = true
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

//
//  HIProjectDetailLocationCell.swift
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

class HIProjectDetailLocationCell: UITableViewCell {

    // MARK: - Properties
    var animator: UIViewPropertyAnimator?

    // MARK: Views
    let mapImageView = UIImageView()
    let mapAnnotation = MKPointAnnotation()
    let titleLabel = HILabel(style: .location) {
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.contentSubtitle
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let containerView = UIView()
    let scrollView = UIScrollView(frame: .zero)

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

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.delegate = self as? UIScrollViewDelegate
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        containerView.addSubview(scrollView)
        scrollView.constrain(to: containerView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        
//        mapImageView.isUserInteractionEnabled = false
//        mapImageView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(mapImageView)
//        mapImageView.constrain(to: containerView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurEffectView)
        blurEffectView.constrain(to: containerView, topInset: 0, trailingInset: 0, leadingInset: 0)
        blurEffectView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.constrain(to: blurEffectView.contentView, topInset: 0, bottomInset: 0)

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
extension HIProjectDetailLocationCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
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
    
    func setZoomScale() {
        mapImageView.sizeToFit()
        scrollView.contentOffset = .zero
        let widthScale = scrollView.bounds.width / (mapImageView.bounds.width * 105)
        let heightScale = scrollView.bounds.height / (mapImageView.bounds.height * 105)
        let minScale = min(widthScale, heightScale)
        let maxScale = max(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        scrollView.zoomScale = minScale
//        mapImageView.center = scrollView.center
    }
}

// MARK: - Population
extension HIProjectDetailLocationCell {
    static func <- (lhs: HIProjectDetailLocationCell, rhs: String) {
        lhs.backgroundColor = UIColor.clear
        lhs.contentView.layer.backgroundColor = UIColor.clear.cgColor
        lhs.titleLabel.text = rhs
        let words = rhs.split(separator: " ")
        let building = words[0]
        let floor = Array(words[1])[0]
        lhs.mapImageView.isUserInteractionEnabled = true
        lhs.mapImageView.image = UIImage(named: "IndoorMap\(building)\(floor)")
        lhs.mapImageView.backgroundColor = UIColor.white
        lhs.scrollView.addSubview(lhs.mapImageView)
//        lhs.mapImageView.constrain(to: lhs.scrollView, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        lhs.scrollView.contentSize = lhs.mapImageView.bounds.size
        lhs.setZoomScale()
    }
}

// MARK: UIScrollViewDelegate
extension HIProjectDetailLocationCell {
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

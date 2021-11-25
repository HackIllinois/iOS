//
//  HICarouselCell.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.

import Foundation
import UIKit

class HICarouselCell: UICollectionViewCell {
    //source: https://medium.com/swlh/swift-carousel-759800aa2952
    // MARK: - Subviews
        
    private lazy var imageView = UIImageView()
    private lazy var titleLabel = HILabel(style: .onboardingTitle)
    private lazy var descriptionLabel = HILabel(style: .onboardingDescription)
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Setups
private extension HICarouselCell {
    func setupUI() {
        backgroundColor = .clear
        
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true    
    }
}

// MARK: - Public
extension HICarouselCell {
    public func configure(image: UIImage?, titleText: String, descriptionText: String) {
        imageView.image = image
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
    }
}

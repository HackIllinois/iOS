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
    // MARK: - SubViews
        
    private lazy var imageView = UIImageView()
    private lazy var textLabel = UILabel()
    
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
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 18)
        textLabel.textColor = .white
    }
}

// MARK: - Public
extension HICarouselCell {
    public func configure(image: UIImage?, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}

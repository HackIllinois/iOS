//
//  HIBaseViewController+UIRefreshControl.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension HIBaseViewController {

    func setupRefreshControl() {
        // Setup refresh control
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(HIBaseViewController.refresh(_:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)

        // Setup refresh animation
        refreshAnimation.loopAnimation = true
        refreshAnimation.contentMode = .scaleAspectFit
        refreshAnimation.frame = .zero
        refreshAnimation.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addSubview(refreshAnimation)

        // Constrain refresh animation
        refreshAnimation.topAnchor.constraint(equalTo: refreshControl.topAnchor).isActive = true
        refreshAnimation.bottomAnchor.constraint(equalTo: refreshControl.bottomAnchor).isActive = true
        refreshAnimation.leftAnchor.constraint(equalTo: refreshControl.leftAnchor).isActive = true
        refreshAnimation.rightAnchor.constraint(equalTo: refreshControl.rightAnchor).isActive = true
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fatalError("refresh(_:) must be implemented in a subclass of HIBaseViewController.")
    }

}

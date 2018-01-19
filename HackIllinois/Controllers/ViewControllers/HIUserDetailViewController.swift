//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/26/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import Lottie

protocol HIUserDetailViewControllerDelegate: class {
    func willDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
    func didDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
}

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HIUserDetailViewControllerDelegate?

    // MARK: - Outlets
    var animationView: UIView!
}

// MARK: - Actions
extension HIUserDetailViewController {
    func dismiss() {
        let animated = true
        delegate?.willDismissViewController(self, animated: animated)
        dismiss(animated: animated) {
            self.delegate?.didDismissViewController(self, animated: animated)
        }
    }
}

// MARK: - UIViewController
extension HIUserDetailViewController {
    override func loadView() {
        super.loadView()
        
        let userDetailContainer = UIView()
        userDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDetailContainer)
        userDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        userDetailContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        userDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        userDetailContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let lookingUpUserLabel = UILabel()
        lookingUpUserLabel.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(lookingUpUserLabel)
        lookingUpUserLabel.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 12).isActive = true
        lookingUpUserLabel.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -12).isActive = true
        lookingUpUserLabel.centerYAnchor.constraint(equalTo: userDetailContainer.centerYAnchor).isActive = true
        
//        let animationView = Animat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        animation.loopAnimation = true
//        animation.frame.size = animationView.frame.size
//        animation.frame.origin = .zero
//        animationView.addSubview(animation)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        animation.completionBlock = { (_) in
//            print("done")
//        }
//        animation.play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        animation.stop()
    }
}

// MARK: - UINavigationItem Setup
extension HIUserDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "PROFILE"
    }
}

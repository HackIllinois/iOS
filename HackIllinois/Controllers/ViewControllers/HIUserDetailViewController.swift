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
//    let animation = LOTAnimationView(name: "loader_ring")

    // MARK: - Outlets
    @IBOutlet weak var animationView: UIView!
}

// MARK: - Actions
extension HIUserDetailViewController {
    @IBAction func dismiss() {
        let animated = true
        delegate?.willDismissViewController(self, animated: animated)
        dismiss(animated: animated) {
            self.delegate?.didDismissViewController(self, animated: animated)
        }
    }
}

// MARK: - UIViewController
extension HIUserDetailViewController {
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

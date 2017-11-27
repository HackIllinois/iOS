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

class HIUserDetailViewController: HIBaseViewController {
    weak var delegate: HIUserDetailViewControllerDelegate?

    @IBOutlet weak var animationView: UIView!
    let animation = LOTAnimationView(name: "loader_ring")

    override func viewDidLoad() {
        super.viewDidLoad()
        animation.loopAnimation = true
        animation.frame.size = animationView.frame.size
        animation.frame.origin = .zero
        animationView.addSubview(animation)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation.completionBlock = { (_) in
            print("done")
        }
        animation.play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animation.stop()
    }

    @IBAction func dismiss() {
        let animated = true
        delegate?.willDismissViewController(self, animated: animated)
        dismiss(animated: animated) {
            self.delegate?.didDismissViewController(self, animated: animated)
        }
    }



}

protocol HIUserDetailViewControllerDelegate: class {
    func willDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
    func didDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
}

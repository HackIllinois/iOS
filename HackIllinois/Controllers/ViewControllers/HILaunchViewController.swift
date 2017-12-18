//
//  HILaunchViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class HILaunchViewController: UIViewController {

    let animationView = LOTAnimationView(name: "data")

    override func viewDidLoad() {
        animationView.contentMode = .scaleAspectFill
        animationView.frame = view.frame
        self.view.addSubview(animationView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play{ (finished) in
            let nextViewController = UIStoryboard(.general).instantiate(HIMenuController.self)
//            nextViewController.transitioningDelegate = self
            self.present(nextViewController, animated: true, completion: nil)
        }
    }

    @IBAction func animateToNextViewController() {
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HIMenuController")
        nextViewController.transitioningDelegate = self
        present(nextViewController, animated: true, completion: nil)
    }
}

extension HILaunchViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LOTAnimationTransitionController(animationNamed: "data", fromLayerNamed: nil, toLayerNamed: nil, applyAnimationTransform: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LOTAnimationTransitionController(animationNamed: "data", fromLayerNamed: nil, toLayerNamed: nil, applyAnimationTransform: true)
    }

}


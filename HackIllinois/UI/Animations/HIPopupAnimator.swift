//
//  HIPopupAnimator.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/26/20.
//  Copyright © 2020 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

// MARK: - PopupAnimation
class HIPopinAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        let transitionContainer = transitionContext.containerView
        let backgroundView = UIView()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .clear
        backgroundView.frame = CGRect(x: fromVC.view.frame.origin.x, y: fromVC.view.frame.origin.y, width: toVC.view.frame.width, height: fromVC.view.frame.height)
        toVC.view.frame = CGRect(x: toVC.view.frame.origin.x, y: toVC.view.frame.height, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
        transitionContainer.addSubview(backgroundView)
        transitionContainer.addSubview(toVC.view)

        UIView.animate(withDuration: animationDuration,
                       animations: { () -> Void in
                        toVC.view.frame = CGRect(x: 0, y: 0, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
                        backgroundView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
        }, completion: {_ in
            backgroundView.removeFromSuperview()
            toVC.view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
            transitionContext.completeTransition(true)
        })
    }
}
// MARK: - PopoutAnimation
class HIPopoutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        let transitionContainer = transitionContext.containerView
        let backgroundView = UIView()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.frame = CGRect(x: toVC.view.frame.origin.x, y: toVC.view.frame.origin.y, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
        backgroundView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
        fromVC.view.backgroundColor = .clear
        transitionContainer.addSubview(backgroundView)
        transitionContainer.addSubview(fromVC.view)

        UIView.animate(withDuration: animationDuration,
                       animations: { () -> Void in
                        fromVC.view.frame = CGRect(x: toVC.view.frame.origin.x, y: toVC.view.frame.height, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
                        backgroundView.backgroundColor = .clear
        }, completion: {_ in
            backgroundView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

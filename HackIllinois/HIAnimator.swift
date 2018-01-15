//
//  HIAnimator.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            //finalize
            return
        }
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        let fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)

        if true {
            toViewStartFrame.origin.x = containerFrame.size.width
            toViewStartFrame.origin.x = containerFrame.size.height
        } else {
//            fromViewFinalFrame = CGRect(x: containerFrame.size.width, y: containerFrame.size.height, width: toView, height: <#T##CGFloat#>)
        }

        containerView.addSubview(toVC.view)
        toVC.view.frame = toViewStartFrame


        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.frame = toViewFinalFrame

        }) { (finished) in
            transitionContext.completeTransition(true)
//            switch transitionContext.transitionWasCancelled {
//            case true:
//                transitionContext.transitionWasCancelled
//            case false:
//            }
        }
    }
}


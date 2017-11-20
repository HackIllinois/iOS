//
//  HIShadeController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HIShadeControllerDelegate {
}

class HIShade: UIView {

}

class HIShadeController: UIViewController {

    /// The tab bar controller’s delegate object.
    var delegate: HIShadeControllerDelegate?

    /// The tab bar view associated with this controller.
    private(set) var tabBar: HIShade = HIShade(frame: CGRect.zero)

    /// An array of the root view controllers displayed by the tab bar interface.
//    @IBOutlet weak var viewControllers: [UIViewController]?

//    ///Sets the root view controllers of the tab bar controller.
//    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
//
//    }

//    /// The subset of view controllers managed by this tab bar controller that can be customized.
//    var customizableViewControllers: [UIViewController]?
//
//    /// The view controller that manages the More navigation interface.
//    var moreNavigationController: UINavigationController

    /// The view controller associated with the currently selected tab item.
    var selectedViewController: UIViewController?

    /// The index of the view controller associated with the currently selected tab item.
    var selectedIndex: Int = 0
}

extension HIShadeController: HIShadeControllerDelegate {

}

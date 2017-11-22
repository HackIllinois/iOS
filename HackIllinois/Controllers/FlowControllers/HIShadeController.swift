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

class HIShadeControllerChildViewController: UIStoryboardSegue {
    override func perform() {
        guard let shadeController = source as? HIShadeController else { fatalError("Invalid storyboard setup: segue.source must be an instance of HIShadeController") }

        shadeController.viewControllers.append(destination)
    }
}

class HIShadeController: UIViewController {

    /// The shade controller’s delegate object.
    var delegate: HIShadeControllerDelegate?

    /// The shade view associated with this controller.
    private(set) var shade: HIShade = HIShade(frame: CGRect.zero)

    /// An array of the root view controllers displayed by the tab bar interface.
    var viewControllers = [UIViewController]()

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

    @IBInspectable var numberOfChildViewControllers: Int = 0


//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(numberOfChildViewControllers > 0, "HIShadeController must have at least one child to manage.")

        for index in 0..<numberOfChildViewControllers {
            performSegue(withIdentifier: "child_\(index)", sender: nil)
        }
    }
}

extension HIShadeController: HIShadeControllerDelegate {

}

//
//  HIMenuController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIMenuController: UIViewController {

    // MARK: Constants
    let MENU_ITEM_HEIGHT: CGFloat = 58

    // MARK: Properties

    private var _tabBarController: UITabBarController?

    override var tabBarController: UITabBarController? {
        get {
            return _tabBarController
        }
        set {
            if _tabBarController == nil {
                _tabBarController = newValue
            }
        }
    }

    @IBOutlet weak var stackViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var contentViewOverlap: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var overlayView: UIView!

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController = childViewControllers.first { $0 is UITabBarController } as? UITabBarController
        tabBarController?.viewControllers?.forEach { (viewController) in
            let _ = viewController.view
        }
        resetMenuItems()
        addMenuItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }

    // MARK: Display menu
    @IBAction func dismissMenu(_ sender: Any) {
        animateClosed()
    }

    // MARK: Menu animation
    func animateOpen() {
        stackViewContainerHeight.constant = stackViewHeight.constant + 11 + 28 + view.safeAreaInsets.top
        contentViewOverlap.constant = -view.safeAreaInsets.top

        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.overlayView.alpha = 0.70
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateClosed() {
        stackViewContainerHeight.constant = 0
        contentViewOverlap.constant = 0

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.overlayView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: Setup stack view buttons
    func addMenuItems() {
        guard let viewControllers = tabBarController?.viewControllers else { return }
        stackViewHeight.constant = CGFloat(viewControllers.count) * MENU_ITEM_HEIGHT

        for (index, viewController) in viewControllers.enumerated() {
            let button = createMenuItem(title: viewController.title, index: index)
            button.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    func resetMenuItems() {
        stackView.arrangedSubviews.forEach { (view) in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        stackViewHeight.constant = 0
    }

    func createMenuItem(title: String?, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = index
        button.heightAnchor.constraint(equalToConstant: MENU_ITEM_HEIGHT).isActive = true
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(named: "darkIndigo"), for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }

    // MARK:
    @objc func didSelectItem(_ sender: UIButton) {
        tabBarController?.selectedIndex = sender.tag
        animateClosed()
    }


}

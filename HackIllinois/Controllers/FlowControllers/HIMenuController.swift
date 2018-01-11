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

    // MARK: - Types
    enum State {
        case open
        case closed
    }

    // MARK: - Constants
    private let MENU_ITEM_HEIGHT: CGFloat = 58

    // MARK: - Properties
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

    private(set) var state = State.closed

    // MARK: - Outlets
    @IBOutlet weak private var stackViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak private var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var stackView: UIStackView!

    @IBOutlet weak private var contentViewOverlap: NSLayoutConstraint!
    @IBOutlet weak private var contentView: UIView!

    @IBOutlet weak private var overlayView: UIView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController = childViewControllers.first { $0 is UITabBarController } as? UITabBarController
        tabBarController?.viewControllers?.forEach { (viewController) in
            let _ = viewController.view
        }
        resetMenuItems()
        createMenuItems()
    }

    // MARK: - Rotation Handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (context) in
            self.animateMenuFor(state: self.state)
        }, completion: nil)
    }

    // MARK: - API
    @IBAction func open(_ sender: Any) {
        guard state != .open else { return }
        state = .open
        animateMenuFor(state: state)
    }

    @IBAction func close(_ sender: Any) {
        guard state != .closed else { return }
        state = .closed
        animateMenuFor(state: state)
    }

    // MARK: Private API
    @objc private func didSelectItem(_ sender: UIButton) {
        tabBarController?.selectedIndex = sender.tag
        close(sender)
    }

    // MARK: - Helpers
    private func updateConstraintsFor(state: State) {
        switch state {
        case .open:
            stackViewContainerHeight.constant = stackViewHeight.constant + 11 + 28 + view.safeAreaInsets.top
            contentViewOverlap.constant = -view.safeAreaInsets.top

        case .closed:
            stackViewContainerHeight.constant = 0
            contentViewOverlap.constant = 0
        }
    }

    private func updateOverlayViewAlphaFor(state: State) {
        switch state {
        case .open:
            overlayView.alpha = 0.70
        case .closed:
            overlayView.alpha = 0.0
        }
    }

    private func animateMenuFor(state: State) {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8)
        updateConstraintsFor(state: state)
        animator.addAnimations {
            self.updateOverlayViewAlphaFor(state: state)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    // MARK: - Menu Setup
    private func createMenuItems() {
        guard let viewControllers = tabBarController?.viewControllers else { return }
        stackViewHeight.constant = CGFloat(viewControllers.count) * MENU_ITEM_HEIGHT

        for (index, viewController) in viewControllers.enumerated() {
            let button = createMenuItem(title: viewController.title, index: index)
            button.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    private func createMenuItem(title: String?, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = index
        button.heightAnchor.constraint(equalToConstant: MENU_ITEM_HEIGHT).isActive = true
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(named: "darkIndigo"), for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }

    private func resetMenuItems() {
        stackView.arrangedSubviews.forEach { (view) in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        stackViewHeight.constant = 0
    }

}

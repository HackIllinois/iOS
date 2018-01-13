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
    // TODO: Introduce MENU_MAX_HEIGHT, add scroll bar if menu height is larger than this value

    // MARK: - Properties
    private var _tabBarController: UITabBarController?

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

        let tabBarController = UITabBarController()
        tabBarController.tabBar.isHidden = true
        addChildViewController(tabBarController)
        tabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tabBarController.view)
        tabBarController.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tabBarController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tabBarController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tabBarController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tabBarController.didMove(toParentViewController: self)
        _tabBarController = tabBarController

        setupViewControllers(
            UIStoryboard(.general).instantiate(HIHomeViewController.self),
            UIStoryboard(.general).instantiate(HIScheduleViewController.self),
            UIStoryboard(.general).instantiate(HIAnnouncmentsViewController.self),
            UIStoryboard(.general).instantiate(HIUserDetailViewController.self),
            UIStoryboard(.general).instantiate(HIScannerViewController.self)
        )

        resetMenuItems()
        createMenuItems()
    }

    // MARK: - Rotation Handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (context) in
            self.animateMenuFor(self.state)
        }, completion: nil)
    }

    // MARK: - API
    func setupViewControllers(_ viewControllers: UIViewController...) {
        _tabBarController?.viewControllers = viewControllers.map {
            _ = $0.view // forces viewDidLoad to run, allows .title to be accessible
            let navigationController = UINavigationController(rootViewController: $0)
            navigationController.title = $0.title
            return navigationController
        }
    }

    @IBAction func open(_ sender: Any) {
        guard state != .open else { return }
        state = .open
        animateMenuFor(state)
    }

    @IBAction func close(_ sender: Any) {
        guard state != .closed else { return }
        state = .closed
        animateMenuFor(state)
    }

    // MARK: Private API
    @objc private func didSelectItem(_ sender: UIButton) {
        _tabBarController?.selectedIndex = sender.tag
        close(sender)
    }

    // MARK: - Helpers
    private func updateConstraintsFor(_ state: State) {
        switch state {
        case .open:
            stackViewContainerHeight.constant = stackViewHeight.constant + 11 + 28 + view.safeAreaInsets.top
            contentViewOverlap.constant = -view.safeAreaInsets.top

        case .closed:
            stackViewContainerHeight.constant = 0
            contentViewOverlap.constant = 0
        }
    }

    private func updateOverlayViewAlphaFor(_ state: State) {
        switch state {
        case .open:
            overlayView.alpha = 0.70

        case .closed:
            overlayView.alpha = 0.0
        }
    }

    private func animateMenuFor(_ state: State) {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8)
        updateConstraintsFor(state)
        animator.addAnimations {
            self.updateOverlayViewAlphaFor(state)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    // MARK: - Menu Setup
    private func createMenuItems() {
        guard let viewControllers = _tabBarController?.viewControllers else { return }
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
        button.setTitleColor(HIColor.darkIndigo, for: .normal)
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

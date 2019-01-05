//
//  HIMenuController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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
    private(set) var state = State.closed

    private(set) var _tabBarController = UITabBarController()

    var overlayView = HIView(style: .overlay)
    var menuItems = UIStackView()

    var menuHeight = NSLayoutConstraint()
    var menuOverlap = NSLayoutConstraint()
    var menuItemsHeight = NSLayoutConstraint()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return HIAppearance.current.preferredStatusBarStyle
    }

    // MARK: - Init
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Actions
extension HIMenuController {
    func setupMenuFor(_ viewControllers: [UIViewController]) {
        _tabBarController.viewControllers = viewControllers.map {
            _ = $0.view // forces viewDidLoad to run, allows .title to be accessible
            $0.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuOpen"), style: .plain, target: self, action: #selector(open))
            return HINavigationController(rootViewController: $0)
        }

        if view != nil {
            resetMenuItems()
            createMenuItems()
        }
    }

    @objc func open(_ sender: Any) {
        guard state != .open else { return }
        state = .open
        animateMenuFor(state)
    }

    @objc func close(_ sender: Any) {
        guard state != .closed else { return }
        state = .closed
        animateMenuFor(state)
    }

    @objc private func didSelectItem(_ sender: UIButton) {
        _tabBarController.selectedIndex = sender.tag
        close(sender)
    }
}

// MARK: - UIViewController
extension HIMenuController {
    override func loadView() {
        view = HIView(style: .background)

        _tabBarController.tabBar.isHidden = true
        addChild(_tabBarController)
        _tabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_tabBarController.view)
        _tabBarController.view.constrain(to: view, trailingInset: 0, leadingInset: 0, widthInset: 0, heightInset: 0)
        
        _tabBarController.didMove(toParent: self)

        overlayView.alpha = 0.0
        view.addSubview(overlayView)
        overlayView.constrain(to: _tabBarController.view, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        

        let menu = HIView(style: .background)
        menu.backgroundColor = HIAppearance.current.background
        menu.clipsToBounds = true
        menu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menu)
        menu.constrain(to: view, topInset: 0, trailingInset: 0, leadingInset: 0)
        
        
        menuOverlap = menu.bottomAnchor.constraint(equalTo: _tabBarController.view.topAnchor)
        menuOverlap.isActive = true
        
        menuHeight = menu.heightAnchor.constraint(equalToConstant: 0)
        menuHeight.isActive = true

        let closeMenuButton = HIButton(style: .icon(image: #imageLiteral(resourceName: "MenuClose")))
        closeMenuButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        closeMenuButton.translatesAutoresizingMaskIntoConstraints = false
        menu.addSubview(closeMenuButton)
        closeMenuButton.topAnchor.constraint(equalTo: menu.safeAreaLayoutGuide.topAnchor, constant: -9).isActive = true
        closeMenuButton.leadingAnchor.constraint(equalTo: menu.safeAreaLayoutGuide.leadingAnchor, constant: 3).isActive = true
        closeMenuButton.widthAnchor.constraint(equalToConstant: 49).isActive = true
        closeMenuButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        menuItems.axis = .vertical
        menuItems.distribution = .fillEqually
        menuItems.translatesAutoresizingMaskIntoConstraints = false
        menu.addSubview(menuItems)
        menuItems.constain(to: menu.safeAreaLayoutGuide, topInset: 11, trailingInset: -59, leadingInset: 59)
        menuItemsHeight = menuItems.heightAnchor.constraint(equalToConstant: 0)
        menuItemsHeight.isActive = true

        let overlayViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close(_:)))
        overlayView.addGestureRecognizer(overlayViewTapGestureRecognizer)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetMenuItems()
        createMenuItems()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (_) in
            self.animateMenuFor(self.state)
        }, completion: nil)
    }
}

// MARK: - Animation
extension HIMenuController {
    private func updateConstraintsFor(_ state: State) {
        switch state {
        case .open:
            menuHeight.constant = menuItemsHeight.constant + 11 + 28 + view.safeAreaInsets.top
            menuOverlap.constant = view.safeAreaInsets.top

        case .closed:
            menuHeight.constant = 0
            menuOverlap.constant = 0
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
        view.layoutIfNeeded()
        updateConstraintsFor(state)
        animator.addAnimations {
            self.updateOverlayViewAlphaFor(state)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

// MARK: - Menu Item Setup
extension HIMenuController {
    private func resetMenuItems() {
        menuItems.arrangedSubviews.forEach { (view) in
            menuItems.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        menuItemsHeight.constant = 0
    }

    private func createMenuItems() {
        let viewControllers = _tabBarController.viewControllers ?? []
        menuItemsHeight.constant = CGFloat(viewControllers.count) * MENU_ITEM_HEIGHT
        for (index, viewController) in viewControllers.enumerated() {
            let button = HIButton(style: .menu(title: viewController.title, tag: index))
            button.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            menuItems.addArrangedSubview(button)
        }
    }
}

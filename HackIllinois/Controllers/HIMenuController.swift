//
//  HIMenuController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIMenuController: UIViewController {

    // MARK: Constants
    let MENU_ITEM_HEIGHT: CGFloat = 58

    // MARK: Properties
    var image: UIImage?

    @IBOutlet weak var stackViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var imageViewOverlap: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var overlayView: UIView!

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = view.frame
        overlayView.frame = view.frame
        navigationItem.hidesBackButton = true
        resetMenuItems()
        addMenuItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateOpen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: Display menu
    static private var _shared: HIMenuController?

    static private var shared: HIMenuController {
        get {
            if _shared == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "HIMenuController")
                guard let menuViewController = viewController as? HIMenuController else { fatalError("Invalid storyboard setup") }
                _shared = menuViewController
            }
            return _shared!
        }
    }

    static func displayMenu(sender: UIViewController) {
        HIMenuController.shared.image = sender.tabBarController?.view.renderAsImage()
        sender.navigationController?.pushViewController(HIMenuController.shared, animated: false)
    }

    @IBAction func dismissMenu(_ sender: Any) {
        animateClosed { _ in
            self.navigationController?.popViewController(animated: false)
        }
    }

    // MARK: Menu animation
    func animateOpen() {
        stackViewContainerHeight.constant = stackViewHeight.constant + 11 + 28 + view.safeAreaInsets.top
        imageViewOverlap.constant = -view.safeAreaInsets.top

        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.overlayView.alpha = 0.70
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateClosed(completion: ((Bool) -> Void)?) {
        stackViewContainerHeight.constant = 0
        imageViewOverlap.constant = 0

        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.overlayView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: completion)
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
        if tabBarController?.selectedIndex != sender.tag {
//            let nextViewController = tabBarController?.viewControllers?[sender.tag]
//            nextViewController?.viewWillAppear(false)
//            nextViewController?.viewDidAppear(false)
//            imageView.image = nextViewController?.view?.renderAsImage()
        }

        animateClosed { _ in
            self.tabBarController?.selectedIndex = sender.tag
            self.navigationController?.popViewController(animated: false)
        }
    }


}

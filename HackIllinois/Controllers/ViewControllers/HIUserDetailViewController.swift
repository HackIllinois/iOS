//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit


protocol HIUserDetailViewControllerDelegate: class {
    func willDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
    func didDismissViewController(_ viewController: HIUserDetailViewController, animated: Bool)
}

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HIUserDetailViewControllerDelegate?

    
    // MARK: - Outlets
    var animationView: UIView!
}

// MARK: - Actions
extension HIUserDetailViewController {
    func dismiss() {
        let animated = true
        delegate?.willDismissViewController(self, animated: animated)
        dismiss(animated: animated) {
            self.delegate?.didDismissViewController(self, animated: animated)
        }
    }
}

// MARK: - Properties
var userImageContainer = UIView()
var userNameLabel = UILabel()
var userInfoLabel = UILabel()


// MARK: - UIViewController
extension HIUserDetailViewController {
    
    override func loadView() {
        super.loadView()
        
        let userDetailContainer = UIView()
        userDetailContainer.layer.cornerRadius = 8
        userDetailContainer.backgroundColor = HIColor.white
        userDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDetailContainer)
        userDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        userDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        userDetailContainer.heightAnchor.constraint(equalToConstant: 430).isActive = true
        

        userImageContainer.backgroundColor = HIColor.darkIndigo
        userImageContainer.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(userImageContainer)
        userImageContainer.topAnchor.constraint(equalTo: userDetailContainer.topAnchor, constant: 48).isActive = true
        userImageContainer.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 42).isActive = true
        userImageContainer.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -42).isActive = true
        userImageContainer.heightAnchor.constraint(equalTo: userImageContainer.widthAnchor).isActive = true
        
        
        let userDataStackContainer = UIView()
        userDataStackContainer.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(userDataStackContainer)
        userDataStackContainer.topAnchor.constraint(equalTo: userImageContainer.bottomAnchor).isActive = true
        userDataStackContainer.bottomAnchor.constraint(equalTo: userDetailContainer.bottomAnchor).isActive = true
        userDataStackContainer.centerXAnchor.constraint(equalTo: userDetailContainer.centerXAnchor).isActive = true
        
        
        let userDataStackView = UIStackView()
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        userDataStackContainer.addSubview(userDataStackView)
        userDataStackView.leadingAnchor.constraint(equalTo: userDataStackContainer.leadingAnchor).isActive = true
        userDataStackView.trailingAnchor.constraint(equalTo: userDataStackContainer.trailingAnchor).isActive = true
        userDataStackView.centerYAnchor.constraint(equalTo: userDataStackContainer.centerYAnchor).isActive = true
        userDataStackView.axis = .vertical
        userDataStackView.alignment = .center
        
        
//        userNameLabel.text = "JOHN DOE"
        userNameLabel.textColor = HIColor.darkIndigo
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userDataStackView.addArrangedSubview(userNameLabel)
        
//        userInfoLabel.text = "DIETARY RESTRICTIONS"
        userInfoLabel.textColor = HIColor.hotPink
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        userDataStackView.addArrangedSubview(userInfoLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        animation.loopAnimation = true
        //        animation.frame.size = animationView.frame.size
        //        animation.frame.origin = .zero
        //        animationView.addSubview(animation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        animation.completionBlock = { (_) in
        //            print("done")
        //        }
        //        animation.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        animation.stop()
    }
}

// MARK: - UINavigationItem Setup
extension HIUserDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "PROFILE"
    }
}

//
//  HIProfileViewController.swift
//  HackIllinois
//
//  Created by Hyosang Ahn on 2/1/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIProfileViewController: HIBaseViewController {
    // MARK: - Properties
    private let editButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "Pencil")
    }
    
    private let contentView = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.action
    }
    private let scrollView = UIScrollView(frame: .zero)
    private let profilePictureView = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
//    var view = UILabel()
//    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//    view.backgroundColor = .white
//
//    view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//
//    var parent = self.view!
//    parent.addSubview(view)
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.widthAnchor.constraint(equalToConstant: 100).isActive = true
//    view.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 138).isActive = true
//    view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 73).isActive = true

    private let userNameLabel = HILabel {
        $0.textHIColor = \.baseText
    }
}

// MARK: - UIViewController
extension HIProfileViewController {
    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = editButton.toBarButtonItem()
        // To add action
        editButton.constrain(width: 22, height: 22)
        // Setup contentView (Display summary)
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        
        contentView.addSubview(profilePictureView)
        profilePictureView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor).isActive = true
        profilePictureView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor).isActive = true
        profilePictureView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor).isActive = true
        profilePictureView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePictureView.image = UIImage(named: "DefaultProfilePicture")
    }
}

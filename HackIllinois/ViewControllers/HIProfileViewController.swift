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
    private let profilePictureView = UIImageView()
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
}

//
//  HIEventDetailViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/21/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEventDetailViewController: HIBaseViewController {

    var model: Event?
    
}

// MARK: - UIViewController
extension HIEventDetailViewController {
    override func loadView() {
        super.loadView()
        // TODO: change to darkbluegrey70
        view.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let eventDetailContainer = UIView(frame: .zero)
        eventDetailContainer.backgroundColor = HIColor.paleBlue
        eventDetailContainer.layer.cornerRadius = 8
        eventDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDetailContainer)
        eventDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64).isActive = true
        eventDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        eventDetailContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
        eventDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        
 
        let directionsButton = UIButton(frame: .zero)
        directionsButton.backgroundColor = HIColor.lightPeriwinkle
        directionsButton.layer.cornerRadius = 8
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.setTitleColor(HIColor.darkIndigo, for: .normal)
        directionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        eventDetailContainer.addSubview(directionsButton)
        directionsButton.leadingAnchor.constraint(equalTo: eventDetailContainer.leadingAnchor, constant: 14).isActive = true
        directionsButton.bottomAnchor.constraint(equalTo: eventDetailContainer.bottomAnchor, constant: -14).isActive = true
        directionsButton.trailingAnchor.constraint(equalTo: eventDetailContainer.trailingAnchor, constant: -14).isActive = true
        directionsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if model == nil {
            presentErrorController(title: "Error", message: "Failed to load event.", dismissParentOnCompletion: true)
        }
    }
}

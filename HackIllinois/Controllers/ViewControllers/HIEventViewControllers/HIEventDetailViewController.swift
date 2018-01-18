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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if model == nil {
            presentErrorController(title: "Error", message: "Failed to load event.", dismissParentOnCompletion: true)
        }
    }

    
}

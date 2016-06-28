//
//  DummyViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

/*
 * This controller resolves the issue of needing to present two different controllers wrapped in the same navigation menu
 * Sadly apple does not provide a way to set conditional root view controllers, so the other solution is to load a "dummy" view controller
 * and from there replace the current view controller in the navigation stack with the actual one preferred.
 */

import UIKit

class DummyViewController: UIViewController {
    
    // TODO: Dynamic roles based off of login data.
    var role = "Staff"

    /*
     * Fetch Role
     */
    func fetchRole() {
        let user: [User] = Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]
        role = user[0].role
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // MARK: Fetch role dynamically
        // fetchRole()
        
        // Roles with simple error checking
        if role == "Hacker" {
            let viewController = UIStoryboard(name: "HelpQ_Hacker", bundle: nil).instantiateInitialViewController()
            self.navigationController?.setViewControllers([viewController!], animated: false)
        } else if role == "Staff" {
            let viewController = UIStoryboard(name: "HelpQ_Staff", bundle: nil).instantiateInitialViewController()
            self.navigationController?.setViewControllers([viewController!], animated: false)
        } else {
            fatalError("No controller found for role")
        }
    }
}

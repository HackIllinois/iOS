//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User = (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile_segue" {
            let profileTable: ProfileTableViewController = segue.destinationViewController as! ProfileTableViewController
            profileTable.user = user
        }
    }
}

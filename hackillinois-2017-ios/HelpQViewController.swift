//
//  HelpQViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController
import CoreData

class HelpQViewController: GenericNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        navigationController?.title = "HelpQ"
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_list_white"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
         */
        // Do any additional setup after loading the view.
        
        
        /*
        if role == "Hacker" {
            let viewController = UIStoryboard(name: "HelpQ_Hacker", bundle: nil).instantiateInitialViewController()
            // self.navigationController?.setViewControllers([viewController!], animated: false)
            self.viewControllers = [viewController!]
            self.pushViewController(viewController!, animated: false)
        } else if role == "Staff" {
            let viewController = UIStoryboard(name: "HelpQ_Staff", bundle: nil).instantiateInitialViewController()
            // self.navigationController?.setViewControllers([viewController!], animated: false)
            self.viewControllers = [viewController!]
            self.pushViewController(viewController!, animated: false)
        } else {
            fatalError("No controller found for role")
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

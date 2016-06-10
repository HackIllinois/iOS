//
//  MainNavigationViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class EventNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.barTintColor = UIColor.fromRGBHex(mainUIColor)
        navigationBar.tintColor = UIColor.fromRGBHex(mainTintColor)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)]
        
        // Reveal view controller
        if self.revealViewController() != nil {
            print("Reveal view controller found")
            
            navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_list_white"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
        }
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

//
//  GenericNavigationController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class GenericNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.barTintColor = UIColor.fromRGBHex(mainUIColor)
        navigationBar.tintColor = UIColor.fromRGBHex(mainTintColor)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)]
        
        // Reveal view controller
        if self.revealViewController() != nil {
            navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_list_white"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
        }
    }
}

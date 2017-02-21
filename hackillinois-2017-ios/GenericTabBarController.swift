//
//  GenericTabBarController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 2/12/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//


//
//  GenericTabBarController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class GenericTabBarController: UITabBarController {
    /*
     * This Controller will handle the Reveal View unless it does not exist.
     * This way, since the TabBar supersedes the Navigation Controller, it will provide a much better experience.
     */
    
    /* View that masks and handles the tap control */
    var tapRecognitionView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set Color of each item
        for item in tabBar.items! {
            item.image = item.image!.withRenderingMode(.alwaysOriginal)
            item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        
    }
}

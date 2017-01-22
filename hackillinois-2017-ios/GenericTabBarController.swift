//
//  GenericTabBarController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class GenericTabBarController: UITabBarController, SWRevealViewControllerDelegate, UIGestureRecognizerDelegate {
    /*
     * This Controller will handle the Reveal View unless it does not exist.
     * This way, since the TabBar supersedes the Navigation Controller, it will provide a much better experience.
     */
    
    /* View that masks and handles the tap control */
    var tapRecognitionView: UIView?
    
    func handleTap() {
        // Simulate tap of close button
        self.revealViewController().revealToggle(animated: true)
    }
 
    // Mark: SWRevealViewController delegates
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right {
            // Add invisible view to pretend as though interaction was disabled
            tapRecognitionView = UIView(frame: self.view.frame)
            // Set up gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tap.delegate = self
            tapRecognitionView?.addGestureRecognizer(tap)
            
            // Properly add the view
            self.view.addSubview(tapRecognitionView!)
            self.view.bringSubview(toFront: tapRecognitionView!)
        } else {
            self.view.isUserInteractionEnabled = true
            tapRecognitionView?.removeFromSuperview()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.tintColor = UIColor.fromRGBHex(mainTintColor)
        tabBar.barTintColor = UIColor.fromRGBHex(mainUIColor)
        
        if self.revealViewController() != nil {
            // Add swiping gesture and custom closing behavior
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set Color of each item
        for item in tabBar.items! {
            item.image = item.image!.withRenderingMode(.alwaysOriginal)
        }
    }
}

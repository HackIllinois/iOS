		//
//  GenericNavigationController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class GenericNavigationController: UINavigationController, SWRevealViewControllerDelegate, UIGestureRecognizerDelegate {
    /*
     * See the GenericTabBarController to see why this class also conforms to SWRevealViewControllerDelegate
     * TODO: Shove similar functions + variables into a helper class
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
        navigationBar.barTintColor = UIColor.fromRGBHex(mainUIColor)
        navigationBar.tintColor = UIColor.fromRGBHex(mainTintColor)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.fromRGBHex(pseudoWhiteColor)]
    
        
        // Reveal view controller
        if self.revealViewController() != nil {
            navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_list_white"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            if self.tabBarController == nil {
                // Add swiping gesture and custom closing behavior, since there is no TabBarController to do so
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.revealViewController().delegate = self
            }
        }
    }
}

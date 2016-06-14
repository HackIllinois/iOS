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
        self.revealViewController().revealToggleAnimated(true)
    }
    
    // Mark: SWRevealViewController delegates
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.Right {
            // Add invisible view to pretend as though interaction was disabled
            tapRecognitionView = UIView(frame: self.view.frame)
            // Set up gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tap.delegate = self
            tapRecognitionView?.addGestureRecognizer(tap)
            
            // Properly add the view
            self.view.addSubview(tapRecognitionView!)
            self.view.bringSubviewToFront(tapRecognitionView!)
        } else {
            self.view.userInteractionEnabled = true
            tapRecognitionView?.removeFromSuperview()
        }
    }
    
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
            
            if self.tabBarController == nil {
                // Add swiping gesture and custom closing behavior, since there is no TabBarController to do so
                print("adding gesture")
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.revealViewController().delegate = self
            }
        }
    }
}

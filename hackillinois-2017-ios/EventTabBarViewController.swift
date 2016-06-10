//
//  MainTabBarViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class EventTabBarViewController: UITabBarController, SWRevealViewControllerDelegate, UIGestureRecognizerDelegate {
    
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
        tabBar.tintColor = UIColor.fromRGBHex(mainTintColor)
        tabBar.barTintColor = UIColor.fromRGBHex(mainUIColor)
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().delegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Set Color of each item
        for item in tabBar.items! {
            item.image = item.image!.imageWithRenderingMode(.AlwaysOriginal)
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

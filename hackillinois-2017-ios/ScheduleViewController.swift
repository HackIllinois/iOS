//
//  ScheduleControllerView.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/4.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    private var pageView: SchedulePageViewController!
    
    struct TabButton {
        var label: UILabel
        var bottomBar: UIView
    }
    
    @IBOutlet weak var fridayTabButtonLabel: UILabel!
    @IBOutlet weak var fridayTabButtonBottomBar: UIView!
    
    @IBOutlet weak var saturdayTabButtonLabel: UILabel!
    @IBOutlet weak var saturdayTabButtonBottomBar: UIView!
    
    @IBOutlet weak var sundayTabButtonLabel: UILabel!
    @IBOutlet weak var sundayTabButtonBottomBar: UIView!

    var tabButtons = [TabButton]()
    let lightsOutColor = UIColor(red: 128.0/255.0, green: 143.0/255, blue: 196.0/255.0, alpha: 1)
    let lightsUpColor = UIColor(red: 93.0/255.0, green: 200.0/255, blue: 219.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background gradient
        let gradient = CAGradientLayer()
        let colorBottom = UIColor(red: 20/255, green: 36/255, blue: 66/255, alpha: 1.0)
        let colorTop = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        gradient.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gradient.locations = [ 0.0, 1.0 ]
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        // Set up transparent navigation bar
        if let navigationBar = self.navigationController?.navigationBar {
            // Set empty pixel as background image
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            // Hide toolbar shadow
            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }

        // Set up buttons array
        tabButtons = [
                TabButton(label: fridayTabButtonLabel, bottomBar: fridayTabButtonBottomBar),
                TabButton(label: saturdayTabButtonLabel, bottomBar: saturdayTabButtonBottomBar),
                TabButton(label: sundayTabButtonLabel, bottomBar: sundayTabButtonBottomBar)
        ]
        
        // Turn lights off for all tabs
        for i in 0...2 {
            lightsOut(forTab: i)
        }
        
        // Listen for pageTurnedEvent from the SchedulePageViewController
        pageView.registerPageTurnedEventListener(listener: { (from: Int, to: Int) in
            self.lightsOut(forTab: from)
            self.lightsUp(forTab: to)
        })
        
        // Select first tab
        changeTab(to: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Store embeded page view for later uses
        if let vc = segue.destination as? SchedulePageViewController {
            if segue.identifier == "PageViewSegue" {
                pageView = vc
            }
        }
    }
    
    // Really hope we have stylesheets like CSS here for this purpose!
    // De-highlights tab label
    func lightsOut(forTab: Int) {
        // Not elegant but whatever
        if ( !( 0 <= forTab && forTab <= 2 ) ) { return }
        
        let tabButton = tabButtons[forTab]
        
        tabButton.label.textColor = lightsOutColor
        tabButton.bottomBar.backgroundColor = UIColor.clear
        tabButton.label.layer.shadowColor = UIColor.clear.cgColor
        tabButton.label.layer.shadowRadius = 0
        tabButton.label.layer.shadowOpacity = 0
        tabButton.bottomBar.layer.shadowColor = UIColor.clear.cgColor
        tabButton.bottomBar.layer.shadowRadius = 0
        tabButton.bottomBar.layer.shadowOpacity = 0
    }
    
    // Highlights tab label
    func lightsUp(forTab: Int) {
        // Not elegant but whatever
        if ( !( 0 <= forTab && forTab <= 2 ) ) { return }
        
        let tabButton = tabButtons[forTab]
        
        tabButton.label.textColor = lightsUpColor
        tabButton.bottomBar.backgroundColor = lightsUpColor
        tabButton.label.layer.shadowColor = lightsUpColor.cgColor
        tabButton.label.layer.shadowRadius = 4
        tabButton.label.layer.shadowOpacity = 1
        tabButton.label.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabButton.bottomBar.layer.shadowColor = lightsUpColor.cgColor
        tabButton.bottomBar.layer.shadowRadius = 4
        tabButton.bottomBar.layer.shadowOpacity = 1
        tabButton.bottomBar.layer.shouldRasterize = true
        tabButton.bottomBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabButton.label.layer.shouldRasterize = true
        tabButton.bottomBar.layer.shouldRasterize = true
        
    }
    
    // Changes tab
    func changeTab(to: Int) {
        //lightsOut(forTab: pageView.pageIndex)
        pageView.turnPage(to: to, withAnimation: true)
        //lightsUp(forTab: pageView.pageIndex)
    }
    
    // Tap listeners
    @IBAction func handleFridayTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("Friday!")
            changeTab(to: 0)
        }
    }
    
    @IBAction func handleSaturdayTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("Saturday!")
            changeTab(to: 1)
        }
    }
    
    @IBAction func handleSundayTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("Sunday!")
            changeTab(to: 2)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

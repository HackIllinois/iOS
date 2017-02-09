//
//  ScheduleDescriptionViewController.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/8.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ScheduleDescriptionViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionStr: String = ""
    var titleStr: String = ""
    var selectedWeekday: String = ""
    
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
        
        // Set up back button
        //self.navigationController?.navigationBar.topItem?.title = selectedWeekday
        self.navigationController?.navigationBar.tintColor = UIColor(red: 93.0/255.0, green: 200.0/255.0, blue: 219.9/255.0, alpha: 1.0)

        // Init text
        titleLabel.text = titleStr
        descriptionLabel.text = descriptionStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

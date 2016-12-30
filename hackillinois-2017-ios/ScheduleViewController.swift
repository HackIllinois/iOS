//
//  ScheduleViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/29/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIToolbarDelegate {
    
    @IBOutlet weak var dayControl: UISegmentedControl!
    @IBOutlet weak var sundayView: UIView!
    @IBOutlet weak var saturdayView: UIView!
    @IBOutlet weak var fridayView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!

    @IBAction func daySelected(_ sender: Any) {
        if dayControl.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.fridayView.alpha = 1
                self.saturdayView.alpha = 0
                self.sundayView.alpha = 0
            })
        } else if(dayControl.selectedSegmentIndex == 1){
            UIView.animate(withDuration: 0.5, animations: {
                self.fridayView.alpha = 0
                self.saturdayView.alpha = 1
                self.sundayView.alpha = 0
            })
        } else if(dayControl.selectedSegmentIndex == 2){
            UIView.animate(withDuration: 0.5, animations: {
                self.fridayView.alpha = 0
                self.saturdayView.alpha = 0
                self.sundayView.alpha = 1
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolbar.delegate = self
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }

}

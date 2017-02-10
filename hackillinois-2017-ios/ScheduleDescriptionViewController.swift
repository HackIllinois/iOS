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

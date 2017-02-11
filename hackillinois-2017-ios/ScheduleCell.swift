//
//  ScheduleCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var actualContent: UIView!
    @IBOutlet weak var reminderButton: UIButton!

    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var cellBorder: UIView!
    
    let highlightedCellBackgroundColor = UIColor(red: 45.0/255.0, green: 70.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    let dehighlightedCellBackgroundColor = UIColor(red: 20.0/255.0, green: 36.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    
    var titleStr: String
    var timeStr: String
    var descriptionStr: String
    var tableCall: (_ location_id: Int) -> Void
    var props: DayItem?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.titleStr = ""
        self.timeStr = ""
        self.descriptionStr = ""
        self.tableCall = { _ in }
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.titleStr = ""
        self.timeStr = ""
        self.descriptionStr = ""
        self.tableCall = { _ in }
        super.init(coder: aDecoder)
    }
    
    @IBAction func locationOnClick(_ sender: UIButton) {
        if let props = props {
            tableCall(props.location_id)
        }
    }
    
    func cellInit(){
        self.selectionStyle = .none
        
        //let leftArrow = UIImage(named: "ic_chevron_right_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //descriptionButton.setImage(leftArrow, for: .normal)
        //descriptionButton.tintColor = descriptionButton.titleColor(for: .normal)
        
        let reminderImage = UIImage(named: "reminder")
        let tintedImage = reminderImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        reminderButton.setImage(tintedImage, for: .normal)
        reminderButton.tintColor = UIColor(red: 128.0/255.0, green: 143.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        reminderButton.imageEdgeInsets = UIEdgeInsetsMake(0, (reminderButton.titleLabel?.frame.size.width)!, 0, 0)
        
        
        self.backgroundColor = UIColor.clear
        
        // hack because color in Interface Builder not matching up with the color defined here
        cellBorder.backgroundColor = highlightedCellBackgroundColor

    }
    
    // Set cell content
    func setEventContent(title: String, time: String, description: String) {
        if let props = props {
            self.title.text = props.name
            self.time.text = props.time
            self.descriptionButton.setTitle(props.location, for: .normal)
        }
    }
    
    func setHappening(_ isHappening: Bool) {
        cellContent.backgroundColor = isHappening ? highlightedCellBackgroundColor : dehighlightedCellBackgroundColor
    }
}

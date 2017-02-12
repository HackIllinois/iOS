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
    @IBOutlet weak var actualContent: UIView!
    @IBOutlet weak var reminderButton: UIButton!

    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var cellBorder: UIView!
    @IBOutlet weak var location1: UIView!
    @IBOutlet weak var locationButton1: UIButton!
    @IBOutlet weak var location1Height: NSLayoutConstraint!
    @IBOutlet weak var location2: UIView!
    @IBOutlet weak var locationButton2: UIButton!
    @IBOutlet weak var location2Height: NSLayoutConstraint!
    @IBOutlet weak var location3: UIView!
    @IBOutlet weak var locationButton3: UIButton!
    @IBOutlet weak var location3Height: NSLayoutConstraint!
    
    
    struct LocationButton {
        var container: UIView
        var button: UIButton
        var constraint: NSLayoutConstraint
    }
    var locationButtons = [LocationButton]()
    
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)    }
    
    required init?(coder aDecoder: NSCoder) {
        self.titleStr = ""
        self.timeStr = ""
        self.descriptionStr = ""
        self.tableCall = { _ in }
        super.init(coder: aDecoder)
    }
    
    func initValues() {
        // location button
        self.locationButtons = [
            LocationButton(container: location1, button: locationButton1, constraint: location1Height),
            LocationButton(container: location2, button: locationButton2, constraint: location2Height),
            LocationButton(container: location3, button: locationButton3, constraint: location3Height)
        ]
    }
    
    @IBAction func locationOnClick(_ sender: UIButton) {
        if let props = props {
            tableCall(props.locations[sender.tag].location_id)
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
        initValues()
        if let props = props {
            self.title.text = props.name
            self.time.text = props.time
            
            for (i, location) in props.locations.enumerated() {
                self.locationButtons[i].button.setTitle(location.location_name, for: .normal)
            }
            for i in stride(from: props.locations.count, through: 2, by: 1) {
                self.locationButtons[i].constraint.constant = -5
            }
            
        }
    }
    
    func setHappening(_ isHappening: Bool) {
        cellContent.backgroundColor = isHappening ? highlightedCellBackgroundColor : dehighlightedCellBackgroundColor
    }
}

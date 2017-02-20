//
//  mainCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var statusLabel: UILabel?
    
    @IBOutlet weak var hoursLabel: UILabel?
    @IBOutlet weak var minutesLabel: UILabel?
    @IBOutlet weak var secondsLabel: UILabel?
    
    @IBOutlet weak var startTimeLabel: UILabel?
    
    @IBOutlet weak var eventLabel: UILabel?
    
    @IBOutlet weak var checkinTimeLabel: UILabel?
    
    
    
    
    
    
    var mTimer = Timer()
    
    var timeRemaining: TimeInterval!
    
    /* if timer is not invalidated the count down clock will go down by two seconds every second */
    override func prepareForReuse() {
        mTimer.invalidate()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /* call the updateCounter function every second */
    func timeStart(){
        mTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    /* decrement seceonds by one and make sure the timer does not overflow */
    func updateCounter() {
        let hrs = timeRemaining / 3600
        let min = (timeRemaining / 60).truncatingRemainder(dividingBy: 60)
        let sec = timeRemaining.truncatingRemainder(dividingBy: 60)
        
        print("HRS: \(hrs)")
        
        hoursLabel?.text = String(format: "%.0f", floor(hrs))
        minutesLabel?.text = String(format: "%.0f", floor(min))
        secondsLabel?.text = String(format: "%.0f", floor(sec))
        
        timeRemaining = timeRemaining - 1.0
    }
    
    
    
}

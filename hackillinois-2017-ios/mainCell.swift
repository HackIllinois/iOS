//
//  mainCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class mainCell: UITableViewCell {
    
    @IBOutlet weak var startsInLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var happeningNowLabel: UILabel!
    
    var mTimer = Timer()
    
    //TODO: Find actual start unix time of event
    let eventStartUnixTime: Int = 1487937827
    let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
    var timeRemaining: Int = 0
    var secondsLeft: Int = 0
    var minutesLeft: Int = 0
    var hoursLeft: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeRemaining = eventStartUnixTime - currentUnixTime
        secondsLeft = getSeconds(timeInSeconds: timeRemaining)
        minutesLeft = getMinutes(timeInSeconds: timeRemaining)
        hoursLeft = getHours(timeInSeconds: timeRemaining)
        timerLabel.text = getTimeRemainingString(hoursLeft: hoursLeft, minutesLeft: minutesLeft, secondsLeft: secondsLeft)
        timerLabel.font = UIFont(name: "Avenir-Light", size: 50);
        timerLabel.textColor = UIColor.fromRGBHex(textHighlightColor);
        
        startsInLabel.font = UIFont(name: "Avenir-Light", size: 20);
        startsInLabel.textColor = UIColor.fromRGBHex(pseudoWhiteColor);
        
        mTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(mainCell.updateCounter), userInfo: nil, repeats: true)

    }
    
    func updateCounter() {
        if(secondsLeft == 0){
            secondsLeft = 59
            minutesLeft -= 1
        }else{
            secondsLeft -= 1
        }
        
        if(minutesLeft == 0){
            minutesLeft = 59
            hoursLeft -= 1
        }
        timerLabel.text = getTimeRemainingString(hoursLeft: hoursLeft, minutesLeft: minutesLeft, secondsLeft: secondsLeft)
    }
    
    func getTimeRemainingString(hoursLeft: Int, minutesLeft: Int, secondsLeft: Int) -> String{
        return String(format:"%02i  %02i  %02i", hoursLeft, minutesLeft, secondsLeft)
    }
    
    func getHours(timeInSeconds: Int) -> Int{
        let hour = (timeInSeconds / 3600)
        return hour
    }
    
    func getMinutes(timeInSeconds: Int) -> Int{
        let minute = ((timeInSeconds % 3600) / (60))
        return minute
    }
    
    func getSeconds(timeInSeconds: Int) -> Int{
        let second = (timeInSeconds % 60)
        return Int(second)
    }

    
}

//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var timerLabel: UILabel!
    var mTimer = Timer()
    
    //TODO: Find actual start unix time of event
    let eventStartUnixTime: Double = 1487937827
    let currentUnixTime: Double = NSDate().timeIntervalSince1970
    var timeRemaining: Double = 0.0
    var secondsLeft: Int = 0
    var minutesLeft: Int = 0
    var hoursLeft: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.timeRemaining = eventStartUnixTime - currentUnixTime
        secondsLeft = getSeconds(timeInSeconds: timeRemaining)
        minutesLeft = getMinutes(timeInSeconds: timeRemaining)
        hoursLeft = getHours(timeInSeconds: timeRemaining)
        
        timerLabel.text = getTimeRemainingString(hoursLeft: hoursLeft, minutesLeft: minutesLeft, secondsLeft: secondsLeft)
        
        
        mTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(HomeViewController.updateCounter), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let secondsString = secondsLeft < 10 ? "0" + String(secondsLeft) : String(secondsLeft)
        let minutesString = minutesLeft < 10 ? "0" + String(minutesLeft) : String(minutesLeft)
        return "" + String(hoursLeft) + ":" + minutesString + ":" + secondsString
    }
    
    func getHours(timeInSeconds: Double) -> Int{
        let hour = (timeInSeconds / Double(3600))
        return Int(hour)
    }

    func getMinutes(timeInSeconds: Double) -> Int{
        let minute = ((timeInSeconds.remainder(dividingBy: 3600.0)) / Double(60))
        return Int(minute)
    }
    
    func getSeconds(timeInSeconds: Double) -> Int{
        let second = ((timeInSeconds.remainder(dividingBy: 3600.0)).remainder(dividingBy: 60.0))
        return Int(second)
    }
}

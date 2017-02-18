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
    
    
    //MARK: - IBActions
    
    @IBAction func qrCodeButton(_ sender: Any) {
        // TODO: Popup view controller to show QR Code
    }
    
    
    
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
        
//        hoursLabel.text =
//        minutesLabel.text =
//        secondsLabel.text =
    }
    
    
    
}

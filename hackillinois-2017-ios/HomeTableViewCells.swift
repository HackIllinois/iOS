//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit

class HomeTableViewEventCell: LocationButtonContainerTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var qrButtonDelegate: QRButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.hiaSeafoamBlue.cgColor
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
    }

    //MARK: - IBActions
    @IBAction func qrCodeButton(_ sender: Any) {
        qrButtonDelegate?.didTapQRButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            containerView.backgroundColor = UIColor.hiaDarkBlueGrey
        } else {
            containerView.backgroundColor = nil
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = nil
        if highlighted {
            containerView.backgroundColor = UIColor.hiaDarkBlueGrey
        } else {
            containerView.backgroundColor = nil
        }
    }
    
}


class HomeTableViewTitleCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTimeLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel?
    @IBOutlet weak var minutesLabel: UILabel?
    @IBOutlet weak var secondsLabel: UILabel?

    @IBOutlet weak var containerView: UIView?

    @IBOutlet weak var eventsTitleLabel: UILabel?
    
    var timer = Timer()
    var isTicking = false
    
    var endTime: Date?
    
    
    // MARK: - UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView?.layer.borderWidth = 2
        containerView?.layer.borderColor = UIColor.hiaDuskyBlue.cgColor
        containerView?.layer.cornerRadius = 5
    }
    
    // MARK: - UITableViewCell
    override func prepareForReuse() {
        timer.invalidate()
        isTicking = false
    }
    
    /* call the updateCounter function every second */
    func timeStart(){
        guard !isTicking else { return }
        isTicking = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    
    /* decrement seceonds by one and make sure the timer does not overflow */
    func updateCounter() {
        guard let endTime = endTime else { return }
        let timeRemaining = max(endTime.timeIntervalSince1970 - Date().timeIntervalSince1970, 0)
        
        let hrs = timeRemaining / 3600
        let min = (timeRemaining / 60).truncatingRemainder(dividingBy: 60)
        let sec = timeRemaining.truncatingRemainder(dividingBy: 60)
        
        hoursLabel?.text   = String(format: "%.0f", floor(hrs))
        minutesLabel?.text = String(format: "%.0f", floor(min))
        secondsLabel?.text = String(format: "%.0f", floor(sec))
    }
}

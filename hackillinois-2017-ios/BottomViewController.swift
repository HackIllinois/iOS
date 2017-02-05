//
//  BottomViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 1/20/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit
import MapKit

class BottomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var directions: MKRoute?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var indoorMap: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.hideView(animate: true)
        self.globalCloseHandler?()
    }
    @IBOutlet weak var indoorMapButtonSmall: UIButton!
    
    @IBOutlet var indoorMapHeight: NSLayoutConstraint!
    @IBOutlet var indoorMapWidth: NSLayoutConstraint!
    
    @IBOutlet weak var navigationTable: UITableView!
    
    /* Variables used to determine splits */
    var y_min : CGFloat!
    var y_max : CGFloat!
    var y_button_h : CGFloat!
    var y_mid: CGFloat!
    
    var globalCloseHandler: ((Void) -> Void)?
    var gesture : UIPanGestureRecognizer? = nil
    var directionShown = false
    var lastSeenTranslation : CGFloat = 0.0
    
    func reloadNavTable(address: String, name: String) {
        navigationTable.reloadData()
        if let directions = directions {
            let miles = directions.distance * 0.00063694
            distanceLabel.text = "\(String(format: "%.1f", miles)) mi" // TODO: change to actual miles
            timeLabel.text = "\(Int(round(directions.expectedTravelTime / 60))) min"
            addressLabel.text = address
            nameLabel.text = name
        } else {
            distanceLabel.text = "" // TODO: change to actual miles
            timeLabel.text = ""
            addressLabel.text = "No Valid Address FIX ME"
            nameLabel.text = ""
        }
    }
    
    func scrollView(y_crd: CGFloat, dur: Double) {
        self.view.removeGestureRecognizer(gesture!)
        UIView.animate(withDuration: dur, animations: {
            self.view.frame = CGRect(x:0, y:y_crd,
                                        width:self.view.frame.width, height:self.view.frame.height)
        }, completion: { finished in
            self.view.addGestureRecognizer(self.gesture!)
        })
    }
    
    func scrollToButtons() {
        /* Scrolls up to where the buttons should show */
        scrollView(y_crd: y_button_h, dur: 0.2)
    }
    
    func scrollToBar() {
        /* Scrolls down to the "hidden" state */
        scrollView(y_crd: y_max, dur: 0.2)
    }
    
    func scrollToTop() {
        scrollView(y_crd: y_min, dur: 0.2)
    }
    
    func scrollToTopSlow() {
        scrollView(y_crd: y_min, dur: 0.4)
    }
    
    func showDirection() {
        if !directionShown {
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                /* Hide the direction button and the indoor map button */
                self.directionButton.alpha = 0.0
                self.indoorMap.alpha = 0.0
                }, completion: { (finished: Bool) -> Void in
                    self.directionButton.isHidden = true
                    self.indoorMap.isHidden = true
                    self.indoorMapButtonSmall.isHidden = false
                    self.addressLabel.isHidden = false
                    UIView.animate(withDuration: 0.2, animations: {
                        self.indoorMapButtonSmall.alpha = 1.0
                        self.addressLabel.alpha = 1.0
                        self.directionShown = true
                    })
            })
        }
    }
    
    func hideDirection() {
        if directionShown {
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                self.indoorMapButtonSmall.alpha = 0.0
                self.addressLabel.alpha = 0.0
                /* Hide the direction button and the indoor map button */
                }, completion: { (finished: Bool) -> Void in
                    self.indoorMapButtonSmall.isHidden = true
                    self.addressLabel.isHidden = true
                    self.directionButton.isHidden = false
                    self.indoorMap.isHidden = false
                    UIView.animate(withDuration: 0.2, animations: {
                        self.directionButton.alpha = 1.0
                        self.indoorMap.alpha = 1.0
                        self.directionShown = false
                    })
            })
        }
    }
    
    func directionTappped() {
        showDirection()
        scrollToTopSlow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        view.addGestureRecognizer(gesture!)
        
        roundViews()
        
        addressLabel.isHidden = true
        addressLabel.alpha = 0.0
        indoorMapButtonSmall.isHidden = true
        indoorMapButtonSmall.alpha = 0.0
        
        // Button stuff
        directionButton.isHidden = false
        directionButton.alpha = 1.0
        indoorMap.isHidden = false
        indoorMap.alpha = 1.0
        
        indoorMapButtonSmall.layer.cornerRadius = 6
        
        directionButton.layer.cornerRadius = 6
        directionButton.layer.borderColor = UIColor.hiaSeafoamBlue.cgColor
        directionButton.layer.borderWidth = 2
        indoorMap.layer.cornerRadius = 6
        
        directionButton.addTarget(self, action: #selector(self.directionTappped), for: .touchDown)
        
        let layerView = view.viewWithTag(10)
        layerView?.layer.borderWidth = 2
        layerView?.layer.cornerRadius = 2
        layerView?.layer.borderColor = UIColor.hiaDarkSlateBlueTwo.cgColor
        
        navigationTable.rowHeight = UITableViewAutomaticDimension
        navigationTable.estimatedRowHeight = 140
        
        /* Set up limits */
        y_min = (self.navigationController?.navigationBar.frame.size.height)! + 25
        y_max = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 125
        y_button_h = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 198
        y_mid = (self.navigationController?.navigationBar.frame.size.height)! + 45
    }
    
    func popOutView() {
        addressLabel.isHidden = true
        addressLabel.alpha = 0.0
        indoorMapButtonSmall.isHidden = true
        indoorMapButtonSmall.alpha = 0.0
        
        // Button stuff
        directionButton.isHidden = false
        directionButton.alpha = 1.0
        indoorMap.isHidden = false
        indoorMap.alpha = 1.0
        
        scrollToBar()
    }
    
    func hideView(animate: Bool) {
        let y_crd = UIScreen.main.bounds.size.height
        if animate {
            scrollView(y_crd: y_crd, dur: 0.5)
        } else {
            scrollView(y_crd: y_crd, dur: 0)
        }
    }
    
    func middleToTop() {
        let y = self.view.frame.minY
        
        if y < y_max-177 {
            scrollToTop()
            showDirection()
        } else {
            scrollToButtons()
            hideDirection()
        }
    }
    
    func topToMiddle() {
        let y = self.view.frame.minY
        
        if y > y_mid {
            scrollToButtons()
            hideDirection()
        } else {
            scrollToTop()
            showDirection()
        }
    }
    
    func middleToBottom() {
        let y = self.view.frame.minY
        
        if y > y_max-55 {
            scrollToBar()
            hideDirection()
        } else {
            scrollToButtons()
            hideDirection()
        }
    }
    
    func bottomToMiddle() {
        let y = self.view.frame.minY
        
        if y < y_max-25 {
            scrollToButtons()
            hideDirection()
        } else {
            scrollToBar()
            hideDirection()
        }
    }
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let y_prime = y+translation.y
        if recognizer.state == UIGestureRecognizerState.ended {
            /* Interpolate location and scroll */
            if y < y_button_h && lastSeenTranslation < 0 {
                middleToTop()
            } else if y < y_button_h && lastSeenTranslation > 0 {
                topToMiddle()
            } else if y > y_button_h && lastSeenTranslation > 0 {
                middleToBottom()
            } else if lastSeenTranslation < 0 {
                bottomToMiddle()
            }
        } else {
            if translation.y != 0 {
                lastSeenTranslation = translation.y
            }
           
            /* Check to see if we exceeded the boundaries */
            if y_prime > y_max {
                self.view.frame = CGRect(x:0, y:y_max,
                                         width:view.frame.width, height:view.frame.height)
            } else if y_prime < y_min {
                self.view.frame = CGRect(x:0, y:y_min,
                                         width:view.frame.width, height:view.frame.height)
            } else {
                self.view.frame = CGRect(x:0, y:y_prime,
                                         width:view.frame.width, height:view.frame.height)
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func prepareBackgroundView() {
        let blurEffect = UIBlurEffect(style: .light)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bluredView.frame = view.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    func roundToNearestTenth(number: Double) -> Int {
        if Int(number / 100) == 0 {
            return Int(round(number/10)) * 10
        }
        
        return Int(round(number / 100)) * 100
    }
    
    func roundViews() {
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Nothing yet
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions?.steps.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "direction_cell", for: indexPath) as! BottomViewTableViewCell
        let feet = floor(((directions?.steps[indexPath.row].distance)! * 3.28084))
        cell.distanceLabel.text = "\(roundToNearestTenth(number: feet)) feet"
        cell.directionLabel.text = directions?.steps[indexPath.row].instructions
        return cell as UITableViewCell
    }
    
}

//
//  BottomViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 1/20/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var indoorMap: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var indoorMapButtonSmall: UIButton!
    
    @IBOutlet var indoorMapHeight: NSLayoutConstraint!
    @IBOutlet var indoorMapWidth: NSLayoutConstraint!
    
    var gesture : UIPanGestureRecognizer? = nil
    var directionShown = false
    var lastSeenTranslation : CGFloat = 0.0
    
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
        let y_crd = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 163
        scrollView(y_crd: y_crd, dur: 0.2)
    }
    
    func scrollToBar() {
        /* Scrolls down to the "hidden" state */
        let y_crd = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 80
        scrollView(y_crd: y_crd, dur: 0.2)
    }
    
    func scrollToTop() {
        let y_crd = (self.navigationController?.navigationBar.frame.size.height)! + 25
        scrollView(y_crd: y_crd, dur: 0.2)
    }
    
    func scrollToTopSlow() {
        let y_crd = (self.navigationController?.navigationBar.frame.size.height)! + 25
        scrollView(y_crd: y_crd, dur: 0.4)
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
        directionButton.layer.borderColor = UIColor(red: 2.0/255, green: 121.0/255.0, blue: 255/255, alpha: 1.0).cgColor
        directionButton.layer.borderWidth = 1
        indoorMap.layer.cornerRadius = 6
        
        directionButton.addTarget(self, action: #selector(self.directionTappped), for: .touchDown)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.size.height-(self?.tabBarController?.tabBar.frame.size.height)! - 163
            self?.view.frame = CGRect(x:0, y:yComponent, width:frame!.width, height:
                frame!.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func middleToTop() {
        let y = self.view.frame.minY
        let y_max = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 80
        
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
        let y_crd = (self.navigationController?.navigationBar.frame.size.height)! + 45
        
        if y > y_crd {
            scrollToButtons()
            hideDirection()
        } else {
            scrollToTop()
            showDirection()
        }
    }
    
    func middleToBottom() {
        let y = self.view.frame.minY
        let y_max = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 80
        
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
        let y_max = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 80
        
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
        let y_min = (self.navigationController?.navigationBar.frame.size.height)! + 25
        let y_max = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 80
        let y_button_h = UIScreen.main.bounds.size.height-(self.tabBarController?.tabBar.frame.size.height)! - 163
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
    
    func roundViews() {
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Nothing yet
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "direction_cell", for: indexPath) as! BottomViewTableViewCell
        return cell as UITableViewCell
    }
    
}

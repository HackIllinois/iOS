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
    
    @IBOutlet weak var directionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        view.addGestureRecognizer(gesture)
        
        roundViews()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 150
            self?.view.frame = CGRect(x:0, y:yComponent, width:frame!.width, height:
                frame!.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        self.view.frame = CGRect(x:0, y:y + translation.y, width:view.frame.width, height:view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        // bluredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bluredView.frame = UIScreen.main.bounds
        view.addSubview(bluredView)
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
        let cell = directionTableView.dequeueReusableCell(withIdentifier: "direction_cell", for: indexPath) as! BottomViewTableViewCell
        return cell as UITableViewCell
    }
    
}

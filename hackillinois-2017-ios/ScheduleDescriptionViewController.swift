//
//  ScheduleDescriptionViewController.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/8.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ScheduleDescriptionViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var dayItem: DayItem?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background gradient
        let gradient = CAGradientLayer()
        let colorBottom = UIColor(red: 20/255, green: 36/255, blue: 66/255, alpha: 1.0)
        let colorTop = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        gradient.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gradient.locations = [ 0.0, 1.0 ]
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        // Set up transparent navigation bar
        if let navigationBar = self.navigationController?.navigationBar {
            // Set empty pixel as background image
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            // Hide toolbar shadow
            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
        // Set up back button
        self.navigationController?.navigationBar.tintColor = UIColor(red: 93.0/255.0, green: 200.0/255.0, blue: 219.9/255.0, alpha: 1.0)

        // Init content
        timeLabel.text = dayItem?.time
        titleLabel.text = dayItem?.name
        locationLabel.text = dayItem?.location
        descriptionLabel.text = dayItem?.descriptionStr
        
        if let imageUrl = dayItem?.imageUrl {
            // load image in background thread
            performSelector(inBackground: #selector(loadImage), with: imageUrl)
        } else if let imageData = dayItem?.imageData {
            // load image by data
            setImage(imageData: imageData)
        }
    }
    
    func loadImage(imageUrl: String) {
        let data = NSData(contentsOf: NSURL(string: imageUrl)! as URL)
        if let data = data {
            performSelector(onMainThread: #selector(setImage), with: data as Data, waitUntilDone: false)
        }
    }
    
    func setImage(imageData: Data) {
        self.imageData = imageData as Data
        
        let dummyImage = UIImage(data: imageData)
        let dummyWidth = dummyImage?.size.width
        let dummyHeight = dummyImage?.size.height
        image.image = dummyImage
        image.isUserInteractionEnabled = true
        imageHeight.constant = (image.frame.width + 30) / dummyWidth! * dummyHeight!
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ScheduleDescriptionImageView") as? ScheduleDetailsImageViewController {
            vc.imageData = imageData
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

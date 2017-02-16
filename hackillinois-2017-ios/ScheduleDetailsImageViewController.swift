//
//  ScheduleDetailsImageViewController.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/10.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit
import WebKit

class ScheduleDetailsImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
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

        
        if let data = imageData {
            // load image data
            scrollView.delegate = self
            
            imageView.image = UIImage(data: data)
            imageView.clipsToBounds = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
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

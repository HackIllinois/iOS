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

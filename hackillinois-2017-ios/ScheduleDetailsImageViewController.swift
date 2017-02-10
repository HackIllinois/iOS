//
//  ScheduleDetailsImageViewController.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/10.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit
import WebKit

class ScheduleDetailsImageViewController: UIViewController {
    var webView: WKWebView!
    var imageUrl: String = ""
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Not safe!
        //webView.loadHTMLString("<img src='" + imageUrl + "'>", baseURL: nil)
        webView.load(URLRequest(url: NSURL(string: imageUrl)! as URL))
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

//
//  HILoginViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import UIKit
import SafariServices

class HILoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        .perform(withAuthorization: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func login() {
        let url = URL(string: "http://ec2-107-20-14-41.compute-1.amazonaws.com/v1/auth")!

        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
}


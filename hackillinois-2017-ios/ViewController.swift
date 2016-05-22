//
//  ViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /* Login View Elements */
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Prettier UI Elements */
        LoginButton.layer.cornerRadius = 5
        LoginButton.clipsToBounds = true
        
        UsernameTextField.layer.borderColor = UIColor.fromRGBHex(0x2c3e50).CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


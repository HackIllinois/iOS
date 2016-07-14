//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var barcodeView: UIImageView!
    
    var user: User = (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeView.image = UIImage(data: user.barcodeData)
    }
}

//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var barcodeView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    
    func loadProfile() {
        nameLabel.text = "Shotaro Ikeda"
        schoolLabel.text = "University of Illinois at Urbana-Champaign"
        majorLabel.text = "Bachelor of Science Computer Science"
        roleLabel.text = "Staff"
        
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
        let barcodeImage = UIImage.generateBarCode("1234567890")!.CIImage?.imageByApplyingTransform(transform)
        barcodeView.image = UIImage(CIImage: barcodeImage!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
    }
}

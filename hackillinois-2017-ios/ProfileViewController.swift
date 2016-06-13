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
        let user = (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first! // Only one User logged in
        nameLabel.text = user.name
        schoolLabel.text = user.school
        majorLabel.text = user.major
        roleLabel.text = user.role
        
        barcodeView.image = UIImage(data: user.barcodeData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
    }
}

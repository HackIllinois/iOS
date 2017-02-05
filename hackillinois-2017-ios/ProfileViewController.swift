//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User = (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    
    @IBOutlet weak var button1: UIImageView!
    @IBOutlet weak var button2: UIImageView!
    @IBOutlet weak var button3: UIImageView!
    @IBOutlet weak var button4: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user.name
        schoolLabel.text = user.school
        majorLabel.text = user.major
        dietLabel.text = user.diet
        
        let gradient = CAGradientLayer()
        let colorBottom = UIColor(red: 20/255, green: 36/255, blue: 66/255, alpha: 1.0)
        let colorTop = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        gradient.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gradient.locations = [ 0.0, 1.0 ]
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationController?.navigationBar.barTintColor = colorTop
        
        let tabColor = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = tabColor
        
        setGestureRecognizers()
    }
    
    func setGestureRecognizers(){
        let tapButton1 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button1Tapped))
        tapButton1.numberOfTapsRequired = 1
        button1.isUserInteractionEnabled = true
        button1.addGestureRecognizer(tapButton1)
        
        let tapButton2 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button2Tapped))
        tapButton2.numberOfTapsRequired = 1
        button2.isUserInteractionEnabled = true
        button2.addGestureRecognizer(tapButton2)
        
        let tapButton3 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button3Tapped))
        tapButton3.numberOfTapsRequired = 1
        button3.isUserInteractionEnabled = true
        button3.addGestureRecognizer(tapButton3)

        let tapButton4 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button4Tapped))
        tapButton4.numberOfTapsRequired = 1
        button4.isUserInteractionEnabled = true
        button4.addGestureRecognizer(tapButton4)

    }
    
    func openLink(link: String){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string:link) as! URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(NSURL(string:link) as! URL)
        }
    }
    func button1Tapped(){
        openLink(link: "https://github.com")
    }
    
    func button2Tapped(){
        print("Button 2")
    }
    
    func button3Tapped(){
        openLink(link: "https://linkedin.com")
    }
    func button4Tapped(){
        print("Needs to be removed")
    }
    
}

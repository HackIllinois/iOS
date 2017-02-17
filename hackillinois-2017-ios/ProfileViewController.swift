//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User = (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        
        
    }
    
    // MARK: TableView - Configure the UITableView
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // heightForRowAtIndexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if (row == 0) {
            return 273
        } else if(row == 1) {
            return 82
        } else {
            return 415
        }
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ProfileViewCell
        let row = indexPath.row
        
        if (row == 0) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for:  indexPath as IndexPath) as! ProfileViewCell
            cell.qrCodeImageView.image = QRCodeGenerator.shared.qrcodeImage
            cell.nameLabel.text = user.name
            cell.dietLabel.text = user.diet
            
        } else if(row == 1) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for:  indexPath as IndexPath) as! ProfileViewCell
            setGestureRecognizers(cell: cell)
            
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for:  indexPath as IndexPath) as! ProfileViewCell
            
            cell.schoolLabel.text = user.school
            cell.schoolLabel.layer.borderWidth = 2.0
            cell.schoolLabel.layer.cornerRadius = 5
            cell.schoolLabel.layer.borderColor = UIColor(red: 78/255, green: 96/255, blue: 148/255, alpha: 1.0).cgColor
            
            cell.majorLabel.text = user.major
            cell.majorLabel.layer.borderWidth = 2.0
            cell.majorLabel.layer.cornerRadius = 5
            cell.majorLabel.layer.borderColor = UIColor(red: 78/255, green: 96/255, blue: 148/255, alpha: 1.0).cgColor
            
//            cell.yearLabel.text = "2019"
//            cell.yearLabel.layer.borderWidth = 2.0
//            cell.yearLabel.layer.cornerRadius = 5
//            cell.yearLabel.layer.borderColor = UIColor(red: 78/255, green: 96/255, blue: 148/255, alpha: 1.0).cgColor
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func setGestureRecognizers(cell: ProfileViewCell){
        let tapButton1 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button1Tapped))
        tapButton1.numberOfTapsRequired = 1
        cell.button1.isUserInteractionEnabled = true
        cell.button1.addGestureRecognizer(tapButton1)
        
        let tapButton2 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button2Tapped))
        tapButton2.numberOfTapsRequired = 1
        cell.button2.isUserInteractionEnabled = true
        cell.button2.addGestureRecognizer(tapButton2)
        
        let tapButton3 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.button3Tapped))
        tapButton3.numberOfTapsRequired = 1
        cell.button3.isUserInteractionEnabled = true
        cell.button3.addGestureRecognizer(tapButton3)
        
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
}

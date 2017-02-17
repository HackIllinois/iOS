//
//  ProfileViewCell.swift
//  hackillinois-2017-ios
//
//  Created by Kevin Rajan on 2/10/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileTableViewQRCell: UITableViewCell {
    @IBOutlet weak var qrCode: UIImageView!
}

class ProfileTableViewNameDietCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
}

class ProfileTableViewLinksCell: UITableViewCell {
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    
    var githubLink: String?
    var resumeLink: String?
    var linkedinLink: String?
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender {
        case githubButton:
            open(link: githubLink)
        case resumeButton:
            open(link: resumeLink)
        case linkedinButton:
            open(link: linkedinLink)
        default:
            break
        }
    }
    
    func open(link: String?) {
        guard let link = link, let url = URL(string: link) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

class ProfileTableViewInformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

//
//  ProfileViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum ProfileTableViewCells: String {
        case QRCode      = "ProfileTableViewQRCell"
        case NameDiet    = "ProfileTableViewNameDietCell"
        case Links       = "ProfileTableViewLinksCell"
        case Information = "ProfileTableViewInformationCell"
    }
    
    var user: User {
        return CoreDataHelpers.getUser()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    
    // MARK: UITableViewDataSource
    var datasource: [ProfileTableViewCells] = [
        .QRCode,
        .NameDiet,
        .Links,
        .Information,
        .Information
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: datasource[indexPath.row].rawValue, for: indexPath)
        
        switch indexPath.row {
        case 0:
            guard let cell = cell as? ProfileTableViewQRCell else { break }
            cell.qrCode.image = QRCodeGenerator.shared.qrcodeImage
            
        case 1:
            guard let cell = cell as? ProfileTableViewNameDietCell else { break }
            cell.nameLabel.text = user.name
            cell.dietLabel.text = user.diet
            
        case 2:
            guard let cell = cell as? ProfileTableViewLinksCell else { break }
            cell.githubLink = "https://github.com"
            cell.resumeLink = "https://google.com"
            cell.linkedinLink = "https://linkedin.com"
            
        case 3:
            guard let cell = cell as? ProfileTableViewInformationCell else { break }
            cell.titleLabel.text = "University"
            cell.detailLabel.text = user.school
            
        case 4:
            guard let cell = cell as? ProfileTableViewInformationCell else { break }
            cell.titleLabel.text = "Major"
            cell.detailLabel.text = user.major

        default:
            break
        }
        
        return cell
    }
}

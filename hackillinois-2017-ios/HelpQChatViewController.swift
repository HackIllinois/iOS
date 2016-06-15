//
//  HelpQChatViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/15/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class HelpQChatViewController: UIViewController {

    @IBOutlet weak var chatView: UIScrollView!
    @IBOutlet weak var techLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    /* label variables */
    var helpqItem: HelpQ!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        techLabel.text = helpqItem.technology
        languageLabel.text = helpqItem.language
        
        if helpqItem.resolved {
            resolutionLabel.text = "Resolved"
            resolutionLabel.textColor = UIColor.greenColor()
        } else {
            resolutionLabel.text = "Unresolved"
            resolutionLabel.textColor = UIColor.redColor()
        }
        
        descriptionLabel.text = helpqItem.description
    }
}

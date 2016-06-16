//
//  HelpQSubmissionViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/16/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class HelpQSubmissionViewController: GenericInputView {

    /* UI Elements */
    @IBOutlet weak var techLabel: UITextField!
    @IBOutlet weak var languageLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /* Button Actions */
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        /* Check if all the labels have text */
        
        let item = HelpQ(technology: techLabel.text!, language: languageLabel.text!, location: locationLabel.text!, description: descriptionLabel.text!)
        addToList(item)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var addToList: (HelpQ -> Void)!
    
    override func viewDidLoad() {
        /* Set superclass variables */
        scroll = scrollView
        textViews = [descriptionLabel]
        textFields = [techLabel, languageLabel, locationLabel]
        
        super.viewDidLoad()
    }
    
}

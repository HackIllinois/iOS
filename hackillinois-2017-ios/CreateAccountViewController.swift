//
//  CreateAccountViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateAccountViewController: GenericInputView {

    /* Button presses */
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        /* Confirm user if they want to actually cancel */
        let ac = UIAlertController(title: "Cancel Creating Account?", message: "Are you sure you would like to cancel creating your account? All changes will be lost.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: { [unowned self] _ in self.dismissViewControllerAnimated(true, completion: nil) }))
        ac.addAction(UIAlertAction(title: "Undo", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        /* Check to see if everything is working */
        
        // Check all fields for input
        if usernameField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            presentError(error: "Empty Fields Found", message: "All fields are required to create an account")
            return
        }
        
        if !stringIsEmail(usernameField.text!) {
            // Username is not an email
            presentError(error: "Invalid Email", message: "Inputted Email is not valid")
            return
        }
        
        if !(passwordField.text! == confirmPasswordField.text!) {
            presentError(error: "Password fields do not match", message: "Password Fields do not match please try again.")
            return
        }
        
        /* Activity Indicator */
        let payload = JSON(["email": usernameField.text!, "password": passwordField.text!, "confirmedPassword": confirmPasswordField.text!])
        if let data = HTTPHelpers.createPostRequest(jsonPayload: payload) {
            print(data)
        }
    }
    
    /* Text Fields */
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    /* Scroll View */
    @IBOutlet weak var scrollView: UIScrollView!
    
    /* Utility functions */
    func presentError(error title: String, message: String) {
        /* Present error with just a cancel option */
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func stringIsEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(email)
    }
    
    override func viewDidLoad() {
        /* Configure super classes' variables */
        scroll = scrollView
        textFields = [usernameField, passwordField, confirmPasswordField]
        textViews = []
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

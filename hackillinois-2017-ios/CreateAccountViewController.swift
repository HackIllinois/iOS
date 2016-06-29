//
//  CreateAccountViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/21/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JWTDecode

class CreateAccountViewController: GenericInputView {
    /* Navigation */
    @IBOutlet weak var navigationBar: UINavigationBar!

    /* Button presses */
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        /* Confirm user if they want to actually cancel */
        let ac = UIAlertController(title: "Changes Will Be Lost", message: "Are you sure you would like to go back to the login page? All text inputs will be lost.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Destructive, handler: { [unowned self] _ in self.dismissViewControllerAnimated(true, completion: nil) }))
        ac.addAction(UIAlertAction(title: "Stay", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /* Super view function to process logins */
    var processUserData: ((name: String, email: String, school: String, major: String, role: String, barcode: String, auth: String, initTime: NSDate, expirationTime: NSDate, userID: NSNumber) -> Void)!
    // This must be set when presenting the view controller.
    
    /* Function passed to capture the response data */
    func captureResponse(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let responseError = error {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.presentError(error: "Error", message: responseError.localizedDescription)
            }
            return
        }
        
        let json = JSON(data: data!)
        
        /* Restore Navigation Bar to regular status */
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            // Title bar configuration
            self.navigationBar.topItem?.title = "Create Account"
            self.navigationBar.topItem?.titleView = nil
            // Disable Buttons
            self.navigationBar.topItem?.leftBarButtonItem?.enabled = true
            self.navigationBar.topItem?.rightBarButtonItem?.enabled = true
        }
        
        /* Handle Errors */
        if !json["error"].isEmpty {
            print("error detected")
            if json["error"]["type"].stringValue == "InvalidParameterError" && json["error"]["source"].stringValue == "email" {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.presentError(error: "Duplicate Email", message: "An account with the email already exists. Please check your email or visit the main website to reset your password")
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.presentError(error: json["error"]["title"].stringValue, message: json["error"]["message"].stringValue)
                }
            }
            return
        } else {
            /* Response from API */
            let auth: String = json["data"]["auth"].string!
            let jwt: JWT = try! decode(auth)
            
            // Calls that are dynamic in this version of API
            let userID: NSNumber = NSNumber(integer: jwt.body["sub"]!.integerValue)
            let role = String(jwt.body["role"]!)
            let email = String(jwt.body["email"]!)
            let initTime : NSDate = jwt.issuedAt!
            let expTime: NSDate = jwt.expiresAt!
            
            print("Role: \(role)")
            print("UserID: \(userID)")
            print("Registration Email: \(email)")
            print("Initialization Time: \(initTime)")
            print("Expiration Time: \(expTime)")
            
            // TODO: Parse data, add User, etc.
            let name = "Shotaro Ikeda"
            let school = "University of Illinois at Urbana-Champaign"
            let major = "Bachelor of Science Computer Science"
            let barcode = "1234567890"
            
            let lambda: (Void -> Void) =  { [unowned self] in
                self.processUserData(name: name, email: email, school: school, major: major, role: role, barcode: barcode, auth: auth, initTime: initTime, expirationTime: expTime, userID: userID)
            }
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.dismissViewControllerAnimated(true, completion: lambda)
            }
        }
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        /* Check to see if everything is working */
        self.view.endEditing(true)
        
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
        
        if passwordField.text!.utf8.count < 8 {
            presentError(error: "Password Too Short", message: "Password must be at least 8 characters long")
            return
        }
        
        if !(passwordField.text! == confirmPasswordField.text!) {
            presentError(error: "Password fields do not match", message: "Password Fields do not match please try again.")
            return
        }
        
        /* Activity Indicator */
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.startAnimating()
        navigationBar.topItem?.title = ""
        navigationBar.topItem?.titleView = activityIndicator
        // Disable Buttons
        navigationBar.topItem?.leftBarButtonItem?.enabled = false
        // navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.grayColor()
        navigationBar.topItem?.rightBarButtonItem?.enabled = false
        // navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.grayColor()
        
        // MARK: Code to be used in actual connection with backend
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            let payload = JSON(["email": self.usernameField.text!, "password": self.passwordField.text!, "confirmedPassword": self.confirmPasswordField.text!])
            print(payload)
            HTTPHelpers.createPostRequest(subUrl: "v1/user", jsonPayload: payload, completion: self.captureResponse)
        }
 
        /*
        // Mimic data processing
        dispatch_after(1 * USEC_PER_SEC, dispatch_get_main_queue()) { [unowned self] in
            let auth: String = "auth dummy data"
            let userID: NSNumber = NSNumber(integer: 1)
            let role = "HACKER"
            let email = "shotaro.ikeda@hackillinois.org"
            let initTime : NSDate = NSDate()
            let expTime: NSDate = NSDate(timeIntervalSinceNow: Double(5 * USEC_PER_SEC * 60)) // Expires in 5 minutes for testing purposes
            
            // TODO: Parse API
            let name = "Shotaro Ikeda"
            let school = "University of Illinois at Urbana-Champaign"
            let major = "Bachelor of Science Computer Science"
            let role = "Staff"
            let barcode = "1234567890"
         
            let lambda: (Void -> Void) =  { [unowned self] in
                self.processUserData(name: name, email: email, school: school, major: major, role: role, barcode: barcode, auth: auth, initTime: initTime, expirationTime: expTime, userID: userID)
            }
            
            self.dismissViewControllerAnimated(true, completion: lambda)
        }
        */
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

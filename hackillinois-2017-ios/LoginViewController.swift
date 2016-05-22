//
//  ViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

// An enumeration to keep track of the
// current user input state
enum UserInputState: UInt8 {
    case NothingEntered = 0
    case UsernameEntered = 1
    case PasswordEntered = 2
    // Add more for different types of errors / more fields
}

class LoginViewController: UIViewController {
    /* Replace these hexidecimal with RGB equivalents */
    let borderColorHex = 0x2c3e50
    
    /* Replace these floats with alpha values for elements */
    let loginElementAlpha: CGFloat = 0.8
    
    
    /* Variables */
    var loginErrorMessage: String? = "You must enter a username and password before logging in."
    var userInputState = UserInputState.NothingEntered.rawValue {
        didSet {
            // Verbose user interface by comparing raw values.
            switch userInputState {
            case UserInputState.NothingEntered.rawValue:
                self.loginErrorMessage = "You must enter a username and password before logging in."
                
            case UserInputState.UsernameEntered.rawValue:
                self.loginErrorMessage = "You must enter a password before logging in."
                
            case UserInputState.PasswordEntered.rawValue:
                self.loginErrorMessage = "You must enter a username before logging in."
                
            default:
                // Default only should apply when 
                // both username and password fields are entered
                self.loginErrorMessage = nil
            }
        }
    }

    /* Login View Elements */
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    /* Login View Element Handlers */
    @IBAction func loginButtonPressed(sender: AnyObject) {
        /* Check if the user has inputted all field via bitmasking */
        // Check username
        if UsernameTextField.text! == "" {
            userInputState = userInputState & ~UserInputState.UsernameEntered.rawValue
        } else {
            userInputState = userInputState | UserInputState.UsernameEntered.rawValue
        }
        
        // Check password
        if PasswordTextField.text! == "" {
            userInputState = userInputState & ~UserInputState.PasswordEntered.rawValue
        } else {
            userInputState = userInputState | UserInputState.PasswordEntered.rawValue
        }
        
        // Check to see if there is an error message, ie the user is missing some information in the field
        if let errorMessage = loginErrorMessage {
            let ac = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            /* MARK: Handle Login here! */
            let username = UsernameTextField.text!
            let password = PasswordTextField.text!
            
            // TODO: Connect to API
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* MARK: Set status bar to look better with image */
        
        /* Prettier UI Elements */
        LoginButton.layer.cornerRadius = 5
        LoginButton.clipsToBounds = true
        LoginButton.alpha = loginElementAlpha
        
        UsernameTextField.layer.borderWidth = 2.5
        UsernameTextField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
        UsernameTextField.alpha = loginElementAlpha
        
        PasswordTextField.layer.borderWidth = 2.5
        PasswordTextField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
        PasswordTextField.alpha = loginElementAlpha
        PasswordTextField.secureTextEntry = true // Password should be hidden
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

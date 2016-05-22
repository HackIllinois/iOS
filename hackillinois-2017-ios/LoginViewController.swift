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
    let loginElementAlpha: CGFloat = 0.9
    
    
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
    
    /* scrollView to make text input look much smoother */
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    /* Keyboard Handlers */
    func keyboardWillAppear(notification: NSNotification) {
        scrollView.scrollEnabled = true
        
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        self.scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        // Only remove inset when keyboard is shown
        scrollView.scrollEnabled = false
        self.scrollView.contentInset = UIEdgeInsetsZero
    }
    
    /* View Controller overrides */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* MARK: Set status bar to look better with image */
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        /* Prettier UI Elements */
        LoginButton.layer.cornerRadius = 5
        LoginButton.clipsToBounds = true
        LoginButton.alpha = loginElementAlpha
        
        UsernameTextField.layer.borderWidth = 4
        UsernameTextField.layer.cornerRadius = 5
        UsernameTextField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
        UsernameTextField.borderStyle = .RoundedRect
        UsernameTextField.alpha = loginElementAlpha
        
        PasswordTextField.layer.borderWidth = 4
        PasswordTextField.layer.cornerRadius = 5
        PasswordTextField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
        PasswordTextField.borderStyle = .RoundedRect
        PasswordTextField.alpha = loginElementAlpha
        PasswordTextField.secureTextEntry = true // Password should be hidden
        
        // Add slight padding to the left to make text less awkward
        let usernamePadding = UIView(frame: CGRectMake(0, 0, 1, PasswordTextField.frame.height))
        UsernameTextField.leftView = usernamePadding
        UsernameTextField.leftViewMode = .Always
        
        let passwordPadding = UIView(frame: CGRectMake(0, 0, 1, PasswordTextField.frame.height))
        PasswordTextField.leftView = passwordPadding
        PasswordTextField.leftViewMode = .Always
        
        /* Set Keyboard actions */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

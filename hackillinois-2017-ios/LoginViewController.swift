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

class LoginViewController: UIViewController, UITextFieldDelegate {
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
            
            login(username: username, password: password)
        }
    }
    
    /* Handle Login */
    func login(username username: String, password: String) {
        // Hide text
        LoginButton.setTitle("", forState: .Normal)
        
        // create activity indicator to show
        let loginActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        // Set the indicator to be the center of the button
        loginActivityIndicator.frame = CGRect(
            x: LoginButton.frame.width / 2 - LoginButton.frame.height / 2,
            y: 0,
            width: LoginButton.frame.height,
            height: LoginButton.frame.height)
        loginActivityIndicator.startAnimating()
        LoginButton.addSubview(loginActivityIndicator)
        
        // disable UI elements while logging in
        LoginButton.userInteractionEnabled = false
        UsernameTextField.userInteractionEnabled = false
        PasswordTextField.userInteractionEnabled = false
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // TODO: Connect to API
            sleep(1) // simulate network response time
            
            let success = true // find if the login was successful or not
            
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    // Login was successful
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateInitialViewController()
                    self.presentViewController(mainViewController!, animated: true, completion: nil)
                } else {
                    // Login was not successful
                    
                    // Re-enable user interaction
                    self.LoginButton.userInteractionEnabled = true
                    self.UsernameTextField.userInteractionEnabled = true
                    self.PasswordTextField.userInteractionEnabled = true
                    // Remove activity indicator
                    loginActivityIndicator.stopAnimating()
                    loginActivityIndicator.removeFromSuperview()
                    // Revert Login button title
                    self.LoginButton.setTitle("Login", forState: .Normal)
                    
                    let loginFailureAlert = UIAlertController(title: "Login Failed", message: "Bad Username / Password", preferredStyle: .Alert)
                    loginFailureAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(loginFailureAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    /* 
     * Keyboard Handlers
     */
    func keyboardWillAppear(notification: NSNotification) {
        scrollView.scrollEnabled = true
        
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        // Animate the keyboard so it looks a lot less awkward...
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.scrollView.contentInset.bottom = keyboardFrame.size.height
        })
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        // Only remove inset when keyboard is shown
        scrollView.scrollEnabled = false
        // Animate the keyboard so it looks a lot less awkward
        // It seems like this line isn't required for the animation to take place for both
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.scrollView.contentInset = UIEdgeInsetsZero
        })
    }
    
    /* Configure behavior of return key. If you are adding more text fields, set the tags in order of how the user should be inputting them. For this login, username has a tag value of 1 and password has a tag value of 2 */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTextFieldTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as UIResponder! {
            // Found next text field to respond to
            nextTextField.becomeFirstResponder()
        } else {
            // There is no next text field
            textField.resignFirstResponder()
            LoginButton.sendActionsForControlEvents(.TouchUpInside) // Fake a button touch as a way to login
        }
        
        return false // Don't insert newlines in textfield
    }
    
    func dismissKeyboard() {
        // force textfield to resign first responder
        view.endEditing(true)
        // Can configure this in keyboardWillDisappear()
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
        
        // Create gesture to recognize when the user taps outside of a textfield to close the keyboard
        let outsideTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(outsideTapped)
        
        /* Set the TextField's delegates to the view controller, required to configure behavior of "next" and "go" keys */
        UsernameTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
    deinit {
        // Destroy all observers
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

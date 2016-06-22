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

class LoginViewController: GenericInputView {
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
    
    /* Create Account */
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        let controller = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateInitialViewController()! as! CreateAccountViewController
        controller.processUserData = processUserData // Capture login function in a different view, so this view will be the one to actually process it
        presentViewController(controller, animated: true, completion: nil)
    }
    
    /* Handle Login */
    func processUserData(success: Bool, name: String, school: String, major: String, role: String, barcode: String, completion: (Void -> Void)?) {
        if !success {
            /* Stay on current login view if not sucessful */
            print("For some reason the login was not successful")
            // Re-enable user interaction
            self.LoginButton.userInteractionEnabled = true
            self.UsernameTextField.userInteractionEnabled = true
            self.PasswordTextField.userInteractionEnabled = true
            // Run Completion code if it exists
            completion?()
            // Revert Login button title
            self.LoginButton.setTitle("Login", forState: .Normal)
            
            let loginFailureAlert = UIAlertController(title: "Login Failed", message: "Bad Username / Password", preferredStyle: .Alert)
            loginFailureAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(loginFailureAlert, animated: true, completion: nil)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // Generate content asynchronously
            /* Generate barcode image */
            let barcodeImage = UIImage.generateRotatedBarCode(barcode)
            // redraw to get NSData
            UIGraphicsBeginImageContext(CGSize(width: 300, height: 1200))
            barcodeImage?.drawInRect(CGRectMake(0, 0, 300, 1200))
            let barCodeImage2 = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let barcodeData = UIImagePNGRepresentation(barCodeImage2)
            
            guard barcodeData != nil else {
                fatalError("BarcodeData is null")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                /* Login was successful */
                // Store user data
                Helpers.storeUser(name: name, school: school, major: major, role: role, barcode: barcode, barcodeData: barcodeData!)
                
                // Store that user has already logged in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setBool(true, forKey: "logged_in_main")
                userDefaults.synchronize()
                
                // Present main application
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = mainStoryboard.instantiateInitialViewController()
                self.presentViewController(mainViewController!, animated: true, completion: nil)
            }
        }
    }
    
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
            sleep(1) // simulate network response time
            
            let success = true // find if the login was successful or not
            
            // TODO: Parse API
            let name = "Shotaro Ikeda"
            let school = "University of Illinois at Urbana-Champaign"
            let major = "Bachelor of Science Computer Science"
            let role = "Staff"
            let barcode = "1234567890"
            
            self.processUserData(success, name: name, school: school, major: major, role: role, barcode: barcode) {
                // Remove activity indicator
                loginActivityIndicator.stopAnimating()
                loginActivityIndicator.removeFromSuperview()
            }
        }
    }
    
    /* Override textfieldshould return */
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
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
    
    /* View Controller overrides */
    override func viewDidLoad() {
        /* Set super class requirements */
        scroll = scrollView
        textFields = [UsernameTextField, PasswordTextField]
        textViews = []
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* MARK: Set status bar to look better with image */
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        /* Prettier UI Elements */
        LoginButton.layer.cornerRadius = 5
        LoginButton.clipsToBounds = true
        LoginButton.alpha = loginElementAlpha
        
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
        createAccountButton.alpha = loginElementAlpha
        
        /* Configure portions that the super class did not configure */
        UsernameTextField.alpha = loginElementAlpha
        
        PasswordTextField.alpha = loginElementAlpha
        PasswordTextField.secureTextEntry = true // Password should be hidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

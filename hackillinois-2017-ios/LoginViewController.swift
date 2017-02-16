//
//  ViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JWTDecode

// An enumeration to keep track of the
// current user input state
enum UserInputState: UInt8 {
    case nothingEntered = 0
    case usernameEntered = 1
    case passwordEntered = 2
    // Add more for different types of errors / more fields
}

class LoginViewController: GenericInputView {
    /* Replace these floats with alpha values for elements */
    let loginElementAlpha: CGFloat = 0.9
    
    /* Variables */
    var loginErrorMessage: String? = "You must enter a username and password before logging in."
    var userInputState = UserInputState.nothingEntered.rawValue {
        didSet {
            // Verbose user interface by comparing raw values.
            switch userInputState {
            case UserInputState.nothingEntered.rawValue:
                self.loginErrorMessage = "You must enter a username and password before logging in."
                
            case UserInputState.usernameEntered.rawValue:
                self.loginErrorMessage = "You must enter a password before logging in."
                
            case UserInputState.passwordEntered.rawValue:
                self.loginErrorMessage = "You must enter a username before logging in."
                
            default:
                // Default only should apply when 
                // both username and password fields are entered
                self.loginErrorMessage = nil
            }
        }
    }
    
    var initialEmail: String?
    
    /* Login View Elements */
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    /* Login View Element Handlers */
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        /* Check if the user has inputted all field via bitmasking */
        // Check username
        if UsernameTextField.text! == "" {
            userInputState = userInputState & ~UserInputState.usernameEntered.rawValue
        } else {
            userInputState = userInputState | UserInputState.usernameEntered.rawValue
        }
        
        // Check password
        if PasswordTextField.text! == "" {
            userInputState = userInputState & ~UserInputState.passwordEntered.rawValue
        } else {
            userInputState = userInputState | UserInputState.passwordEntered.rawValue
        }
        
        // Check to see if there is an error message, ie the user is missing some information in the field
        if let errorMessage = loginErrorMessage {
            let ac = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            /* MARK: Handle Login here! */
            let username = UsernameTextField.text!
            let password = PasswordTextField.text!
            
            login(username: username, password: password)
        }
    }
    
    /* Handle Login */
    func processUserData(name: String, email: String, school: String, major: String, role: String, barcode: String, auth: String, initTime: Date, expirationTime: Date, userID: NSNumber, diet: String) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            // Generate content asynchronously
            /* Generate barcode image */
            let barcodeImage = UIImage.generateBarCode(barcode)
            // redraw to get NSData
            UIGraphicsBeginImageContext(CGSize(width: 1200, height: 300))
            barcodeImage?.draw(in: CGRect(x: 0, y: 0, width: 1200, height: 300))
            let barCodeImage2 = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let barcodeData = UIImagePNGRepresentation(barCodeImage2!)
            
            guard barcodeData != nil else {
                fatalError("BarcodeData is null")
            }
            
            DispatchQueue.main.async {
                /* Login was successful */
                // Store user data
                CoreDataHelpers.storeUser(name: name, email: email, school: school, major: major, role: role, barcode: barcode, barcodeData: barcodeData!, auth: auth, initTime: initTime, expirationTime: expirationTime, userID: userID, diet: diet)
                
                // Present main application
                let mainStoryboard = UIStoryboard(name: "Event", bundle: nil)
                let mainViewController = mainStoryboard.instantiateInitialViewController()
                self.present(mainViewController!, animated: true, completion: nil)
            }
        }
    }
    
    func processError(_ responseData: JSON) {
        // Handle NotFoundError
        if responseData["error"]["type"].stringValue == "NotFoundError" {
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "Could Not Find User", message: "A user with the specified email could not be found. Please try again", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
//      else {
//            // Handle other unsupported errors
//            DispatchQueue.main.async {
//                let ac = UIAlertController(title: responseData["error"]["title"].string!, message: responseData["error"]["message"].string!, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(ac, animated: true, completion: nil)
//            }
//        }
        
        // Restore to original view
        DispatchQueue.main.async { [unowned self] in
            /* Stay on current login view if not sucessful */
            
            // Re-enable user interaction
            self.LoginButton.isUserInteractionEnabled = true
            self.UsernameTextField.isUserInteractionEnabled = true
            self.PasswordTextField.isUserInteractionEnabled = true
            // Revert Login button title
            self.LoginButton.setTitle("Login", for: UIControlState())
            
            self.loginActivityIndicator.stopAnimating()
            self.loginActivityIndicator.removeFromSuperview()
        }
    }
    
    /* Activity Indicator for processing information */
    var loginActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white) // Reusable
    
    func processResponse(_ data: Data?, response: URLResponse?, error: NSError?) {
        var responseData = JSON(data: data!)
        
        print(responseData)
        /* Check for any errors */
        if (responseData["error"]).isEmpty {
            processError(responseData)
            return // Attemping to decode the jwt actually makes it crash
        }
        print("reached here!!!!!!")
        
        
        
        
        
        /* Response from API */
        let auth: String = responseData["data"]["auth"].stringValue
        print(responseData)
        print("AUTH: \(auth)")
        let jwt: JWT = try! decode(jwt: auth)
        
        
        
        // Calls that are dynamic in this version of API
        print("JWT: \(jwt)")
        
        let userID: NSNumber = NSNumber(value: jwt.body["sub"]!.integerValue)
        let role = String(describing: jwt.body["roles"]!)
        let email = String(describing: jwt.body["email"]!)
        let initTime : Date = jwt.issuedAt! as Date
        let expTime: Date = jwt.expiresAt! as Date
        
        print("Role: \(role)")
        print("UserID: \(userID)")
        print("Registration Email: \(email)")
        print("Initialization Time: \(initTime)")
        print("Expiration Time: \(expTime)")
        
        // TODO: Parse API
        
        let name = "Shotaro Ikeda"
        let school = "University of Illinois at Urbana-Champaign"
        let major = "Bachelor of Science Computer Science"
        let barcode = "1234567890"
        let diet = "No restrictions"
        
        
        self.processUserData(name: name, email: email, school: school, major: major, role: role, barcode: barcode, auth: auth, initTime: initTime, expirationTime: expTime, userID: userID, diet: diet)
    }
    
    func login(username: String, password: String) {
        // Hide text
        LoginButton.setTitle("", for: UIControlState())
        
        // Set the indicator to be the center of the button
        loginActivityIndicator.frame = CGRect(
            x: LoginButton.frame.width / 2 - LoginButton.frame.height / 2,
            y: 0,
            width: LoginButton.frame.height,
            height: LoginButton.frame.height)
        loginActivityIndicator.startAnimating()
        LoginButton.addSubview(loginActivityIndicator)
        
        // disable UI elements while logging in
        LoginButton.isUserInteractionEnabled = false
        UsernameTextField.isUserInteractionEnabled = false
        PasswordTextField.isUserInteractionEnabled = false
        
        /* MARK: For api branch */
        DispatchQueue.global(qos: .userInitiated).async {
            /* Remove all previous users */
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            for user in (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]) {
                appDelegate.managedObjectContext.delete(user)
            }
            
            let payload: JSON = JSON(["email": username, "password": password])
            HTTPHelpers.createPostRequest(subUrl: "v1/auth", jsonPayload: payload, completion: self.processResponse)
            
        }
        /*
        // Send request to server
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            /* Remove all previous users */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            for user in (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]) {
                appDelegate.managedObjectContext.deleteObject(user)
            }
         
            let payload: JSON = JSON(["email": username, "password": password])
            HTTPHelpers.createPostRequest(subUrl: "v1/auth", jsonPayload: payload, completion: self.processResponse)
        }
        */
        
        /* Mark: Fake server response -- Remove an uncomment code above to run */
        /*
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1 * USEC_PER_SEC)) { [unowned self] in
            /* Remove all previous users */
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            for user in (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]) {
                appDelegate.managedObjectContext.delete(user)
            }
            
            let payload: JSON = JSON(["email": username, "password": password])
            HTTPHelpers.createPostRequest(subUrl: "v1/auth", jsonPayload: payload, completion: self.processResponse)
            
        }
        /*
         // Send request to server
         dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
         /* Remove all previous users */
         let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         
         for user in (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]) {
         appDelegate.managedObjectContext.deleteObject(user)
         }
         
         let payload: JSON = JSON(["email": username, "password": password])
         HTTPHelpers.createPostRequest(subUrl: "v1/auth", jsonPayload: payload, completion: self.processResponse)
         }
         */
        
        /* Mark: Fake server response -- Remove an uncomment code above to run */
        /*
         DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1 * USEC_PER_SEC)) { [unowned self] in
         /* Remove all previous users */
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         for user in (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]) {
         appDelegate.managedObjectContext.delete(user)
         }
         /* Response from API */
         let auth: String = "auth dummy data"
         let userID: NSNumber = NSNumber(value: 1 as Int)
         let role = "HACKER"
         let email = "shotaro.ikeda@hackillinois.org"
         let initTime : Date = Date()
         let expTime: Date = Date(timeIntervalSinceNow: Double(5 * 60)) // Expires in 5 minutes for testing purposes
         let diet = "No restrictions"
         
         // TODO: Parse API
         let name = "Shotaro Ikeda"
         let school = "University of Illinois at Urbana-Champaign"
         let major = "Bachelor of Science Computer Science"
         let barcode = "1234567890"
         self.processUserData(name: name, email: email, school: school, major: major, role: role, barcode: barcode, auth: auth, initTime: initTime, expirationTime: expTime, userID: userID, diet: diet)
         }
         */

        */
    }
    
    /* Override textfieldshould return */
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTextFieldTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as UIResponder! {
            // Found next text field to respond to
            nextTextField.becomeFirstResponder()
        } else {
            // There is no next text field
            textField.resignFirstResponder()
            LoginButton.sendActions(for: .touchUpInside) // Fake a button touch as a way to login
        }
        
        return false // Don't insert newlines in textfield
    }
    
    /* View Controller overrides */
    override func viewDidLoad() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        /* Set super class requirements */
        textFields = [UsernameTextField, PasswordTextField]
        textViews = []
 
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* MARK: Set status bar to look better with image */
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        /* Prettier UI Elements */
        LoginButton.layer.cornerRadius = 5
        LoginButton.clipsToBounds = true
        LoginButton.alpha = loginElementAlpha
        
        /* Configure portions that the super class did not configure */
        UsernameTextField.alpha = loginElementAlpha
        UsernameTextField.text = initialEmail
        
        PasswordTextField.alpha = loginElementAlpha
        PasswordTextField.isSecureTextEntry = true // Password should be hidden
 
        
        let gradient = CAGradientLayer()
        let colorBottom = UIColor(red: 20/255, green: 36/255, blue: 66/255, alpha: 1.0)
        let colorTop = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        gradient.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gradient.locations = [ 0.0, 1.0 ]
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
 
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

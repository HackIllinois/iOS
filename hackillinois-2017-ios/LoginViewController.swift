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


class LoginViewController: UIViewController, UITextFieldDelegate {

    var loginActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white) // Reusable
    
    var initialEmail: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = initialEmail ?? "ios@hackillinois.org"
        passwordTextField.text = "testtest"
        
        loginActivityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard
    func keyboardWillAppear(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveValue),
            let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        view.layoutIfNeeded()
        
        // UIAutoLayoutEngine Animations
        containerCenterYConstraint.isActive = false
        containerBottomConstraint.constant = keyboardFrame.height
        containerBottomConstraint.isActive = true

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        logo.alpha = 0
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveValue) else { return }
        
        view.layoutIfNeeded()
        // UIAutoLayoutEngine Animations
        containerBottomConstraint.isActive = false
        containerBottomConstraint.constant = 0
        containerCenterYConstraint.isActive = true

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        logo.alpha = 1
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            attemptLogin()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }

    // MARK: - Login Logic
    @IBAction func attemptLogin() {
        guard let (username, password) = localValidateLoginFields() else { return }
        
        presentBusyFormUI()
        
        APIManager.shared.getAuthKey(username: username, password: password, success: getAuthKeySuccess, failure: getAuthKeyFailure)
    }
    
    func getAuthKeySuccess(json: JSON) {
        if let error = json["error"]["message"].string {
            presentErrorLabel(text: error)
        } else if let key = json["data"]["auth"].string {
            APIManager.shared.setAuthKey(key)
            APIManager.shared.getUserInfo(success: getUserInfoSuccess, failure: getUserInfoFailure)
        } else {
            presentActiveFormUI()
        }
    }
    
    func getAuthKeyFailure(error: Error) {
        presentActiveFormUI()
        presentErrorLabel(text: "Unknown Error")
    }
    
    func getUserInfoSuccess(json: JSON) {
        print(json)
        let data = json["data"]
        let name = "\(data["firstName"]) \(data["lastName"])"
        let email = usernameTextField.text!
        let school = String(describing: data["school"])
        let major = String(describing: data["major"])
        let barcode = "1234567890" // CHANGE THIS
        let role = "ROLE"
        let userID = data["userId"] as! NSNumber
        var diet = String(describing: data["diet"])
        if diet == "NONE" {
            diet = "No dietary restrictions"
        }
        let auth = APIManager.shared.auth_key
//        let initTime = jwt.issuedAt! as Date
//        let expTime = jwt.expiresAt! as Date
        let initTime: Date = Date()
        let expirationTime: Date = Date()
        processUserData(name: name, email: email, school: school, major: major, role: role, barcode: barcode, auth: auth!, initTime: initTime, expirationTime: expirationTime, userID: userID, diet: diet)
        
    }
    
    func getUserInfoFailure(error: Error) {
        presentActiveFormUI()
        presentErrorLabel(text: "Unknown Error")
    }


    @IBAction func ibLocalValidateLoginFields() {
        localValidateLoginFields()
    }
    
    @discardableResult
    func localValidateLoginFields() -> (username: String, password: String)? {
        guard let username = usernameTextField.text, username != "" else {
            presentErrorLabel(text: "Empty Username")
            return nil
        }
        
        guard let password = passwordTextField.text, password != "" else {
            presentErrorLabel(text: "Empty Password")
            return nil
        }
        
        let passwordLength = password.characters.count
        
        guard passwordLength >= 8  else  {
            presentErrorLabel(text: "Password too short")
            return nil
        }
        
        guard passwordLength <= 50  else  {
            presentErrorLabel(text: "Password too long")
            return nil
        }

        hideErrorLabel()
        
        return (username, password)
    }
    
    
    // MARK: - Login UI
    func presentErrorLabel(text: String) {
        errorLabel.text = text
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.errorLabel.alpha = 1
        }
    }
    
    func hideErrorLabel() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.errorLabel.alpha = 0
        }
    }
    
    func presentActiveFormUI() {
        loginActivityIndicator.removeFromSuperview()

        loginButton.setTitle("Log in", for: .normal)

        loginButton.isEnabled = true
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
    }
    
    func presentBusyFormUI() {
        loginButton.setTitle("", for: .normal)
        
        loginActivityIndicator.frame = CGRect(
            x: loginButton.frame.width / 2 - loginButton.frame.height / 2,
            y: 0,
            width: loginButton.frame.height,
            height: loginButton.frame.height)
        loginButton.addSubview(loginActivityIndicator)
        
        
        // disable UI elements while logging in
        loginButton.isEnabled = false
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
    }

    // MARK: - junk
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
      else {
            // Handle other unsupported errors
            DispatchQueue.main.async {
                let ac = UIAlertController(title: responseData["error"]["title"].string!, message: responseData["error"]["message"].string!, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
        
        // Restore to original view
        DispatchQueue.main.async { [unowned self] in
            /* Stay on current login view if not sucessful */
            
            // Re-enable user interaction
            self.loginButton.isUserInteractionEnabled = true
            self.usernameTextField.isUserInteractionEnabled = true
            self.passwordTextField.isUserInteractionEnabled = true
            // Revert Login button title
            self.loginButton.setTitle("Login", for: UIControlState())
            self.loginActivityIndicator.stopAnimating()
            self.loginActivityIndicator.removeFromSuperview()
        }
    }
    
    
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
        let initTime = jwt.issuedAt! as Date
        let expTime = jwt.expiresAt! as Date
        
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
}

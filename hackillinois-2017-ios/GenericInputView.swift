//
//  GenericInputView.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/16/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class GenericInputView: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var textViews: [UITextView]!
    var textFields: [UITextField]!
    
    @IBOutlet var topConstraint: NSLayoutConstraint?
    @IBOutlet var bottomConstraint: NSLayoutConstraint?
    @IBOutlet var logo: UIImageView?
    
    var originalConstraint: CGFloat!
    
    var outsideTapped: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        /* Set Keyboard actions */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Create gesture to recognize when the user taps outside of a textfield to close the keyboard
        outsideTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(outsideTapped)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.removeGestureRecognizer(outsideTapped)
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        originalConstraint = bottomConstraint?.constant
        
        /* Configure each textview */
        for textView in textViews {
            textView.layer.borderWidth = 4
//            textView.layer.borderWidth = 4
            textView.layer.cornerRadius = 5
//            textView.layer.borderColor = UIColor.fromRGBHex(borderColorHex).cgColor
            textView.textContainerInset = UIEdgeInsetsMake(5, 2.5, 5, 2.5)
//            textView.textColor = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1) // Placeholder default color for iOS 9
            textView.delegate = self
        }
        
//        textFields[0].tag = 0
//        textFields[1].tag = 1
        
        
        


        /* Configure each textField */
        for textField in textFields {
            // Add padding to the left side
//            let inputTextPadding = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: textField.frame.height))
//            textField.leftView = inputTextPadding
//            textField.leftViewMode = .always
            
            // Set Better UI Elements
//            textField.layer.borderWidth = 4
//            textField.layer.borderWidth = 4
//            textField.layer.cornerRadius = 5
//            textField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).cgColor
//            textField.borderStyle = .roundedRect
            
            // Set delegate as self
            textField.delegate = self
        }
//        textFields[0].returnKeyType = .next
//        textFields[1].returnKeyType = .done
//        print("textFields[0]: \(textFields[0].tag)")
//        print("textFields[1]: \(textFields[1].tag)")

    }
    
    /*
     * Keyboard Handlers
     */
    func keyboardWillAppear(_ notification: Notification) {
        
        print("KeyboardWillAppear")
        
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveValue),
            let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        view.layoutIfNeeded()
        bottomConstraint?.constant = keyboardFrame.height + 25
        logo?.alpha = 0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        
        view.layoutIfNeeded()

        UIView.commitAnimations()
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        print("KeyboardWillDisappear")
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveValue) else { return }
        
        view.layoutIfNeeded()
        bottomConstraint?.constant = originalConstraint
        logo?.alpha = 1
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        
        view.layoutIfNeeded()

        
        UIView.commitAnimations()
    
        
        }
    
    // Mark: UITextFieldDelegate
    /* Configure behavior of return key. If you are adding more text fields, set the tags in order of how the user should be inputting them. For this login, username has a tag value of 0 and password has a tag value of 1 */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("tag is \(textField.tag)")
        
        let nextTextFieldTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as UIResponder! {
            print("found next responder")
            // Found next text field to respond to
            nextTextField.becomeFirstResponder()
        } else {
            // There is no next text field
            textField.resignFirstResponder()
        }
        
        return false // Don't insert newlines in textfield
    }
    
    func dismissKeyboard() {
        // force textfield to resign first responder
        view.endEditing(true)
        // Can configure this in keyboardWillDisappear()
    }
    
    // Mark: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        if textView.text == "Description here..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        if textView.text == "" {
            textView.text = "Description here..."
            textView.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        }
        
        textView.resignFirstResponder()
    }
    deinit {
    }
}

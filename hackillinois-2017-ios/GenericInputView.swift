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
    var scroll: UIScrollView!
    
    var outsideTapped: UITapGestureRecognizer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        /* Set Keyboard actions */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear), name: UIKeyboardWillHideNotification, object: nil)
        
        // Create gesture to recognize when the user taps outside of a textfield to close the keyboard
        outsideTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(outsideTapped)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        view.removeGestureRecognizer(outsideTapped)
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure each textview */
        for textView in textViews {
            textView.layer.borderWidth = 4
            textView.layer.borderWidth = 4
            textView.layer.cornerRadius = 5
            textView.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
            textView.textContainerInset = UIEdgeInsetsMake(5, 2.5, 5, 2.5)
            textView.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22) // Placeholder default color for iOS 9
            textView.delegate = self
        }
        
        /* Configure each textField */
        for textField in textFields {
            // Add padding to the left side
            let inputTextPadding = UIView(frame: CGRectMake(0, 0, 1, textField.frame.height))
            textField.leftView = inputTextPadding
            textField.leftViewMode = .Always
            
            // Set Better UI Elements
            textField.layer.borderWidth = 4
            textField.layer.borderWidth = 4
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UIColor.fromRGBHex(borderColorHex).CGColor
            textField.borderStyle = .RoundedRect
            
            // Set delegate as self
            textField.delegate = self
        }
    }
    
    /*
     * Keyboard Handlers
     */
    func keyboardWillAppear(notification: NSNotification) {
        scroll.scrollEnabled = true
        
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        // Animate the keyboard so it looks a lot less awkward...
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.scroll.contentInset.bottom = keyboardFrame.size.height
        })
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        // Only remove inset when keyboard is shown
        scroll.scrollEnabled = false
        // Animate the keyboard so it looks a lot less awkward
        // It seems like this line isn't required for the animation to take place for both
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.scroll.contentInset = UIEdgeInsetsZero
        })
    }
    
    // Mark: UITextFieldDelegate
    /* Configure behavior of return key. If you are adding more text fields, set the tags in order of how the user should be inputting them. For this login, username has a tag value of 1 and password has a tag value of 2 */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTextFieldTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as UIResponder! {
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
    
    // Mark: UITextVieDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Description here..." {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description here..."
            textView.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        }
        textView.resignFirstResponder()
    }
    
    deinit {
    }
}

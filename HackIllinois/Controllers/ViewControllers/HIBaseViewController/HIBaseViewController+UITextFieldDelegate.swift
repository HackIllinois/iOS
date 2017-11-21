//
//  HIBaseViewController+UITextFieldDelegate.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension HIBaseViewController: UITextFieldDelegate {

    func nextReponder(current: UIResponder) -> UIResponder? {
        return nil
    }

    func actionForFinalResponder() { }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextReponder = nextReponder(current: textField) {
            nextReponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            actionForFinalResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }

}

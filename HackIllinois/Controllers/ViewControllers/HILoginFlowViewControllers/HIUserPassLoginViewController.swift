//
//  HIUserPassLoginViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit


protocol HIUserPassLoginViewControllerDelegate: class {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController)

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forUsername username: String, andPassword password: String)
}

class HIUserPassLoginViewController: HIBaseViewController {

    var delegate: HIUserPassLoginViewControllerDelegate?

    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var usernameTextFeild: UITextField!

    @IBAction func didSelectBack(_ sender: UIButton) {
        delegate?.userPassLoginViewControllerDidSelectBackButton(self)
    }

    @IBAction func didSelectLogin(_ sender: UIButton) {
        guard let username = usernameTextFeild.text, let password = passwordTextFeild.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forUsername: username, andPassword: password)
    }

    // responder chain
    override func nextReponder(current: UIResponder) -> UIResponder? {
        switch current {
        case usernameTextFeild:
            return passwordTextFeild
        case passwordTextFeild:
            return nil
        default:
            return nil
        }
    }

    override func actionForFinalResponder() {
        guard let username = usernameTextFeild.text, let password = passwordTextFeild.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forUsername: username, andPassword: password)
    }

}

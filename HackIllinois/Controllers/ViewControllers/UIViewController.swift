//
//  UIViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    @IBAction func openMenu(_ sender: UIButton) {
        HIMenuController.displayMenu(sender: self)
    }

}

//
//  UIViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

// TODO: Change to extension on HIBaseViewController
extension UIViewController {

    @IBAction func openMenu(_ sender: UIButton) {
        (tabBarController?.parent as? HIMenuController)?.open(sender)
    }

}

extension UIViewController: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

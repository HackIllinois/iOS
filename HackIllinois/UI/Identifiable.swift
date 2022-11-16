//
//  Identifiable.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/8/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

//protocol Identifiable {
//    static var identifier: String { get }
//}

extension UITableViewCell: Identifiable {
    static var identifier: String = String(describing: self)
}

extension UITableViewHeaderFooterView: Identifiable {
    static var identifier: String = String(describing: self)
}

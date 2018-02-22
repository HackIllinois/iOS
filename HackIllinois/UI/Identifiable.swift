//
//  Identifiable.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/8/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension UITableViewCell: Identifiable {
    static var identifier: String = String(describing: self)
}

extension UITableViewHeaderFooterView: Identifiable {
    static var identifier: String = String(describing: self)
}

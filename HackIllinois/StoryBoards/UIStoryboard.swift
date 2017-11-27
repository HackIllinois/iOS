//
//  UIStoryboard.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/26/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    /// The uniform place where we state all the storyboard we have in our application

    enum Storyboard: String {
        case main   = "Main"
        case modals = "Modals"

        var filename: String {
            return rawValue
        }
    }


    // MARK: - Convenience Initializers
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    func instantiate<T: StoryboardIdentifiable>(_ type: T.Type, additionalConfigutation configuration: ((T) -> Void)?) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        configuration?(viewController)
        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}


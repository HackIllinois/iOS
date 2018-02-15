//
//  UIView.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 2/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import UIKit

private let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension UIView {
    static let swizzle: Void = {
        let originalSelector = #selector(addSubview(_:))
        let swizzledSelector = #selector(hiswizzle_addSubview(_:))
        swizzling(UIView.self, originalSelector, swizzledSelector)
    }()

    // MARK: - Method Swizzling
    @objc func hiswizzle_addSubview(_ view: UIView) {
        hiswizzle_addSubview(view)
        print("added subView: \(view)")
    }
}

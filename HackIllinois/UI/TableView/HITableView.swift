//
//  HITableView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HITableView: UITableView {
    // MARK: - Types

    // MARK: - Properties

    // MARK: - Init
    init() {
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false

        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        indicatorStyle <- \.scrollViewIndicatorStyle
        backgroundColor <- \.clear
    }
    
    // MARK: - Swipe Gesture Support
    func addLeftAndRightSwipeGestureRecognizers(target: Any?, selector: Selector?) {
        let leftGestureRecognizer = UISwipeGestureRecognizer(
            target: target,
            action: selector
        )
        leftGestureRecognizer.direction = .left
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(
            target: target,
            action: selector
        )
        rightGestureRecognizer.direction = .right
        
        self.addGestureRecognizer(leftGestureRecognizer)
        self.addGestureRecognizer(rightGestureRecognizer)
    }

}

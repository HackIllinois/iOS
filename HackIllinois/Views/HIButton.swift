//
//  HIButton.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIButton: UIButton {
    // MARK: - Types
    enum Style: Equatable {
        case standard(title: String)
        case async(title: String)
        
        var rawValue: Int {
            switch self {
            case .standard:
                return 0
            case .async:
                return 1
            }
        }
        
        static func ==(lhs: HIButton.Style, rhs: HIButton.Style) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }

    // MARK: - Properties
    let style: Style
    var activityIndicator: UIActivityIndicatorView?

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)

        backgroundColor = HIApplication.Color.lightPeriwinkle
        layer.cornerRadius = 8
        setTitleColor(HIApplication.Color.darkIndigo, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .standard(let title):
            setTitle(title, for: .normal)

        case .async(let title):
            setTitle(title, for: .normal)
            let activityIndicator = UIActivityIndicatorView()
            addSubview(activityIndicator)
            activityIndicator.tintColor = HIApplication.Color.hotPink
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            self.activityIndicator = activityIndicator
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    func setAsyncTask(running: Bool) {
//        assert(style == HIButton.StUIyle.async)

    }
}

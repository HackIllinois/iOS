//
//  HIDateHeader.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HIDateHeader: UITableViewHeaderFooterView {
    var titleLabel = HILabel {
        $0.textHIColor = \.titleText
        $0.backgroundHIColor = \.clear
        $0.font = HIAppearance.Font.sectionHeader
    }
    
    let testView = HIView { (view) in
        view.layer.cornerRadius = 10
        view.backgroundHIColor = \.buttonDarkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let backgroundView = HIView { $0.backgroundHIColor = \.clear }
        self.backgroundView = backgroundView

        var con: CGFloat = 2.25
        if UIDevice.current.userInterfaceIdiom == .pad {
            con = 5.0
        } else if UIScreen.main.bounds.width < 375.0 {
            con = 1.1
        }
        
        backgroundView.addSubview(testView)
        testView.addSubview(titleLabel)
        testView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -8).isActive = true
        testView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 68 * con).isActive = true
        testView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        testView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -68 * con).isActive = true
        titleLabel.constrain(to: testView, topInset: 4, trailingInset: -16, bottomInset: -4, leadingInset: 16)
        //backgroundView.addSubview(titleLabel)
        /*titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -14).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 14).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -14).isActive = true*/
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

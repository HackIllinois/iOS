//
//  HIButton.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/8/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import SwiftUI

struct HIButtonSUI: View {
    // MARK: - Properties
    var title: String?
    var activeImage: UIImage?
    var baseImage: UIImage?
    var titleHIColor: HIColor?
    var tintHIColor: HIColor?
    var backgroundHIColor: HIColor?
    
    @State private var isActive = false
    
    /* when is this ran
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        self.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activityIndicator
    }()
    */
    
    /* what is this
    var isRunning: Bool = false {
        willSet {
            guard newValue != isRunning else { return }
            if newValue {
                isEnabled = false
                setTitle(nil, for: .normal)
                backgroundColor = UIColor.lightGray
                activityIndicator.startAnimating()
            } else {
                isEnabled = true
                setTitle(title, for: .normal)
                backgroundColor <- backgroundHIColor
                activityIndicator.stopAnimating()
            }
        }
    }
    */

    var body: some View {
        Button {
            toggleButton()
        } label: {
            HStack {
                if let activeImage = activeImage, let baseImage = baseImage {
                    Image(uiImage: isActive ? activeImage: baseImage)
                }
                if let title = title {
                    Text(title)
                        .foregroundColor(Color(titleHIColor!.value))
                }
            }
            .background(Color(backgroundHIColor!.value))
        }
    }

    func toggleButton() {
        isActive.toggle()
    }
    
    /* how to update colors? Binding?
    @objc func refreshForThemeChange() {
        setTitleColor(titleHIColor?.value, for: .normal)
        activityIndicator.tintColor <- tintHIColor
        tintColor <- tintHIColor
        backgroundColor <- backgroundHIColor
    }
    */
    
    // Do we need to handle all the Touch Up/Down/Drag, SwiftUI has good default handling
}

struct HIButtonSUI_Previews: PreviewProvider {
    static var previews: some View {
        HIButtonSUI()
    }
}

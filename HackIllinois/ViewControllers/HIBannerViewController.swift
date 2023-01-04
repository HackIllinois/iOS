//
//  HIBannerViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/30/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIBannerViewController: UIViewController {
    private let backgroundHIColor: HIColor = \.clear
}

extension HIBannerViewController {
    override func loadView() {
        view = HIView { $0.backgroundHIColor = \.clear }

        let bannerStackView = UIStackView()
        bannerStackView.distribution = .fillEqually
        bannerStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerStackView)
        bannerStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bannerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bannerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bannerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        

        let daysContent = bannerView(with: "HACKILLINOIS BEGINS IN")
        bannerStackView.addArrangedSubview(daysContent)
    }
    
    func bannerView(with labelString: String) -> UIView {
        //bannerView.backgroundColor <- backgroundHIColor

        let label = HILabel {
            $0.textHIColor = \.whiteText
            $0.backgroundHIColor = \.clear
            $0.textAlignment = .center
            $0.font = HIAppearance.Font.glyph
            $0.text = labelString
        }

        let bannerView = UIView()
        bannerView.addSubview(label)
        label.constrain(to: bannerView, topInset: 0, trailingInset: 0, leadingInset: 0)
        bannerView.constrain(to: bannerView, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        bannerView.bottomAnchor.constraint(equalTo: label.topAnchor).isActive = true

        return bannerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}



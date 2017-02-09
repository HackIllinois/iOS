//
//  EventDetails.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 08/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad();
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
    }
    func goBack() {
        self.dismiss(animated: true, completion: nil);
    }
}

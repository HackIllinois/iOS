//
//  GenericNavigationController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 2/12/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit

class GenericNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar.barTintColor = UIColor.hiaDarkSlateBlue
        navigationBar.tintColor = UIColor.hiaDarkSlateBlue
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.hiaPaleGrey]
        navigationBar.alpha = 1
        navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default;
        
    }
}

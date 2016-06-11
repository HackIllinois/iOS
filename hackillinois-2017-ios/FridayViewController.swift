//
//  FridayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class FridayViewController: GenericDayViewController {
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        collectionView = collection
        
        for n in 0..<10 {
            let item = DayItem(name: "Friday Event \(n)", location: "REPLACE ME", time: "MM:DD PM")
            dayItems.append(item)
        }
        
        super.viewDidLoad()
    }
}

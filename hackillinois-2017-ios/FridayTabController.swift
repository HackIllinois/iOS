//
//  FridayTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class FridayTabController: GenericTabController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initIndex()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initIndex()
    }
    
    func initIndex(){
        dayIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleDescStr = String(repeating: "This event contains a clickable image.\n", count: 10)
        
        // Friday
        for n in 0..<10 {
            let location_id = arc4random_uniform(4)
            let location_names = [
                "DCL",
                "Siebel",
                "ECEB",
                "Union"
            ]
            /* let sampleImages = [
                ["title": "Siebel Center", "url": "https://cs.illinois.edu/sites/default/files/images/banners/banner_whycs.png"],
                ["title": "HackIllinois", "url": "https://cs.illinois.edu/sites/default/files/images/banners/hackillinois2017.png"]
            ] */

            
            let item = DayItem(
                name: "Friday Event \(n)",
                location: location_names[Int(location_id)],
                time: "MM:DD PM",
                description: sampleDescStr,
                highlighted: arc4random_uniform(2) == 0,
                location_id: Int(location_id) + 1
            )
            //let randomImageIndex = Int(arc4random_uniform(UInt32(sampleImages.count)))
            //item.imageTitle = sampleImages[randomImageIndex]["title"]
            //item.imageUrl = sampleImages[randomImageIndex]["url"]
            item.setImage(title: "Test Image", data: UIImagePNGRepresentation(#imageLiteral(resourceName: "test_img"))!)
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
    }
}

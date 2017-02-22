//
//  DayItemLocation.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/11.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit

class DayItemLocation: NSObject {
    var location_name: String
    var location_shortname: String
    var location_id: Int
    
    init(id: Int, name: String, shortname: String) {
        self.location_name = name
        self.location_shortname = shortname
        self.location_id = id
    }
}

//
//  HIMapsDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/16/19.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

final class HIMapsDataSource {

    struct IndoorMap {
        struct Floor {
            let name: String
            let image: UIImage
        }
        let name: String
        let floors: [Floor]
    }

    static let shared = HIMapsDataSource()

    private init() { }

    let maps: [IndoorMap] = {
        var maps = [IndoorMap]()
        // Siebel
        maps.append(
            IndoorMap(
                name: "Siebel",
                floors: [
                    IndoorMap.Floor(name: "Basement", image: #imageLiteral(resourceName: "IndoorMapSiebel1")),
                    IndoorMap.Floor(name: "1st Floor", image: #imageLiteral(resourceName: "IndoorMapSiebel2")),
                    IndoorMap.Floor(name: "2nd Floor", image: #imageLiteral(resourceName: "IndoorMapSiebel3"))
                ]
            )
        )

        // ECEB
        maps.append(
            IndoorMap(
                name: "ECEB",
                floors: [
                    IndoorMap.Floor(name: "1st Floor", image: #imageLiteral(resourceName: "IndoorMapECEB1")),
                    IndoorMap.Floor(name: "2nd Floor", image: #imageLiteral(resourceName: "IndoorMapECEB2")),
                    IndoorMap.Floor(name: "3rd Floor", image: #imageLiteral(resourceName: "IndoorMapECEB3"))
                ]
            )
        )

        // DCL
        maps.append(
            IndoorMap(
                name: "DCL",
                floors: [IndoorMap.Floor(name: "1st Floor", image: #imageLiteral(resourceName: "IndoorMapDCL"))]
            )
        )

        return maps
    }()
}

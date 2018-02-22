//
//  HIWalletBadge.swift
//  HackIllinois
//
//  Created by Yasha Mostofi on 2/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation

struct HIWalletBadge: Encodable {
    struct Location: Encodable {
        let longitude: Double
        let latitude: Double
    }
    struct Barcode: Encodable {
        let message: String = "123"
        let format: String = "PKBarcodeFormatPDF417"
        let messageEncoding: String = "iso-8859-1"
    }
    struct Ticket: Encodable {
        let primaryFields: [Field]
        let secondaryFields: [Field]
    }
    struct Field: Encodable {
        let key: String
        let label: String
        let value: String
    }
    let formatVersion: Int = 1
    let passTypeIdentifier: String = "pass.com.hackillinois.ios"
    let serialNumber: String = "nmyuxofgna" // some user unique thing
    let relevantDate: String = "2018-02-23T16:00-6:00"
    let locations: [Location] = [
        Location(
            longitude: -88.2249,
            latitude: 40.1138
        ),
        Location(
            longitude: -88.228023,
            latitude: 40.114921
        )
    ]
    let barcode: Barcode = Barcode()
    let organizationName: String = "HackIllinois"
    let description: String = "HackIllinois 2018 Badge"
    let foregroundColor: String = "rgb(28, 5, 94)"
    let backgroundColor: String = "rgb(242, 245, 254)"
    let eventTicket: Ticket = Ticket(
        primaryFields: [Field(key: "event", label: "EVENT", value: "Dream it. Build it.")],
        secondaryFields: [Field(key: "loc", label: "LOCATION", value: "UIUC")]
    )
}
/*
{
    "authenticationToken" : "vxwxd7J8AlNNFPS8k0a0FfUFtq0ewzFdc",
}
*/

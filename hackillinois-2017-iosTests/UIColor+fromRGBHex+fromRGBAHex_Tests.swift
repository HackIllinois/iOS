//
//  UIColor+fromRGBHex+fromRGBAHex_Tests1.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import XCTest
import UIKit

@testable import hackillinois_2017_ios

class UIColor_fromRGBHex_fromRGBAHex_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testColorConversionRGB() {
        let color = UIColor.init(red: 44.0 / 255, green: 62.0 / 255, blue: 80.0 / 255, alpha: 1.0)
        let colorRGB = UIColor.fromRGBHex(0x2c3e50)
        
        XCTAssertTrue(color.isEqual(colorRGB))
    }
    
    func testColorConversionRGBA() {
        let color = UIColor.init(red: 44.0 / 255, green: 62.0 / 255, blue: 80.0 / 255, alpha: 1.0)
        let colorRGBA = UIColor.fromRGBAHex(0x2c3e50FF)
        
        XCTAssertTrue(color.isEqual(colorRGBA))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

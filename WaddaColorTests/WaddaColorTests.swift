//
//  WaddaColorTests.swift
//  WaddaColorTests
//
//  Created by Johan Sørensen on 23/02/16.
//  Copyright © 2016 Johan Sørensen. All rights reserved.
//

import XCTest
@testable import WaddaColor

class WaddaColorTests: XCTestCase {

    func testIsItBlackOrWhite() {
        XCTAssertEqual(UIColor.blackColor().name, "Black")
        XCTAssertEqual(UIColor.whiteColor().name, "White")
    }
    
}

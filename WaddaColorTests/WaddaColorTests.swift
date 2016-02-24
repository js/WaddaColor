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

    func testRGBEquality() {
        let a = RGBA(12, 13, 14, 0.5)
        let b = RGBA(12, 13, 14, 0.5)
        XCTAssertTrue(a == b)
    }

    func testIsItBlackOrWhite() {
        XCTAssertEqual(UIColor.blackColor().name, "Black")
        XCTAssertEqual(UIColor.whiteColor().name, "Daisy")
    }

    func testBlackish() {
        let wadda = WaddaColor(color: UIColor(white: 0.01, alpha: 1.0))
        let blackish = wadda.closestMatch()
        XCTAssertEqual(blackish.name, "Ink")
        XCTAssertEqualWithAccuracy(blackish.distance, 0.548, accuracy: 0.001)
    }

    private func roundToPlaces(val: Double, places: Int = 3) -> Double {
        let pow10np = pow(Double(10), Double(places))
        return  round(val * pow10np) / pow10np
    }

    func testWhiteish() {
        let wadda = WaddaColor(color: UIColor(white: 0.99, alpha: 1.0))
        let whitish  = wadda.closestMatch()
        XCTAssertEqual(whitish.name, "Daisy")
        XCTAssertEqualWithAccuracy(whitish.distance, 1.036, accuracy: 0.001)
    }

    func testRGBtoXYZ() {
        let xyz = XYZ(rgb: RGBA(128, 128, 128, 1.0))
        XCTAssertEqual(roundToPlaces(xyz.x), 20.518)
        XCTAssertEqual(roundToPlaces(xyz.y), 21.586)
        XCTAssertEqual(roundToPlaces(xyz.z), 23.507)
    }

    func testXYZtoLAB() {
        let xyz = XYZ(rgb: RGBA(128, 128, 128, 1.0))
        let lab = LAB(xyz: xyz)
        XCTAssertEqual(roundToPlaces(lab.l), 53.585)
        XCTAssertEqual(roundToPlaces(lab.a), 0.003)
        XCTAssertEqual(roundToPlaces(lab.b), -0.006)
    }

    func testRGBtoHSL() {
        let rgb = RGBA(128, 54, 43, 1.0)
        let hsl = HSL(rgb: rgb)
        XCTAssertEqualWithAccuracy(hsl.hue, 7.765, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(hsl.saturation, 49.708, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(hsl.lightness, 33.529, accuracy: 0.001)
    }

    func testHSLisDarkOrLight() {
        let dark = HSL(rgb: RGBA(33, 33, 33, 1.0))
        XCTAssertTrue(dark.isDark())
        XCTAssertFalse(dark.isLight())

        let light = HSL(rgb: RGBA(243, 243, 243, 1.0))
        XCTAssertTrue(light.isLight())
        XCTAssertFalse(light.isDark())
    }

    func testDistance() {
        let black = RGBA(0, 0, 0, 1.0)
        let almostBlack = RGBA(1, 1, 1, 1.0)
        let gray = RGBA(127, 127, 127, 1.0)
        let white = RGBA(255, 255, 255, 1.0)

        XCTAssertEqual(roundToPlaces(black.distanceTo(white)), 100.000)
        XCTAssertEqual(roundToPlaces(black.distanceTo(gray)), 53.193)
        XCTAssertEqual(roundToPlaces(black.distanceTo(almostBlack)), 0.274)
        XCTAssertEqual(black.distanceTo(black), 0.0)
    }


}

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
        let a = RGBA(12/255, 13/255, 14/255, 0.5)
        let b = RGBA(12/255, 13/255, 14/255, 0.5)
        XCTAssertTrue(a == b)
    }

    func testIsItBlackOrWhite() {
        XCTAssertEqual(UIColor.blackColor().name, "Black")
        XCTAssertEqual(UIColor.whiteColor().name, "Daisy")
    }

    func testBlackish() {
        let wadda = WaddaColor(color: UIColor(white: 0.01, alpha: 1.0))
        let blackish = wadda.closestMatch()
        XCTAssertEqual(blackish.name, "Jade")
        XCTAssertEqualWithAccuracy(blackish.distance, 0.669, accuracy: 0.001)
    }

    func testWhiteish() {
        let wadda = WaddaColor(color: UIColor(white: 0.99, alpha: 1.0))
        let whitish  = wadda.closestMatch()
        XCTAssertEqual(whitish.name, "Daisy")
        XCTAssertEqualWithAccuracy(whitish.distance, 0.880, accuracy: 0.001)
    }

    func testRGBtoXYZ() {
        let xyz = XYZ(rgb: RGBA(0.5, 0.5, 0.5, 1.0))
        XCTAssertEqualWithAccuracy(xyz.x, 20.345, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(xyz.y, 21.404, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(xyz.z, 23.309, accuracy: 0.001)
    }

    func testXYZtoLAB() {
        let xyz = XYZ(rgb: RGBA(0.5, 0.5, 0.5, 1.0))
        let lab = LAB(xyz: xyz)
        XCTAssertEqualWithAccuracy(lab.l, 53.389, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lab.a, 0.003, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lab.b, -0.006, accuracy: 0.001)
    }

    func testRGBtoHSL() {
        let rgb = RGBA(128/255, 54/255, 43/255, 1.0)
        let hsl = HSL(rgb: rgb)
        XCTAssertEqualWithAccuracy(hsl.hue, 7.765, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(hsl.saturation, 49.708, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(hsl.lightness, 33.529, accuracy: 0.001)

        let redHSL = HSL(rgb: RGBA(1, 0, 0, 1))
        XCTAssertEqual(redHSL.hue, 0)
        XCTAssertEqual(redHSL.saturation, 100)
        XCTAssertEqual(redHSL.lightness, 50)
    }

    func testHSLisDarkOrLight() {
        let dark = HSL(rgb: RGBA(33/255, 33/255, 33/255, 1.0))
        XCTAssertTrue(dark.isDark())
        XCTAssertFalse(dark.isLight())

        let light = HSL(rgb: RGBA(243/255, 243/255, 243/255, 1.0))
        XCTAssertTrue(light.isLight())
        XCTAssertFalse(light.isDark())
    }

    func testDistance() {
        let black = RGBA(0, 0, 0, 1.0)
        let almostWhite = RGBA(0.99, 0.99, 0.99, 1.0)
        let gray = RGBA(0.5, 0.5, 0.5, 1.0)
        let white = RGBA(1, 1, 1, 1.0)

        XCTAssertEqualWithAccuracy(black.distanceTo(white), 100.000, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(black.distanceTo(gray), 53.389, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(black.distanceTo(almostWhite), 99.1195, accuracy: 0.0001)
        XCTAssertEqual(black.distanceTo(black), 0.0)
    }

    func testLuminance() {
        let black = WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        let almostWhite = WaddaColor(r: 0.99, g: 0.99, b: 0.99, a: 1.0)
        let almostWhite2 = WaddaColor(r: 0.85, g: 0.85, b: 0.85, a: 1.0)
        let gray = WaddaColor(r: 0.5, g: 0.5, b: 0.5, a: 1.0)
        let white = WaddaColor(r: 1, g: 1, b: 1, a: 1.0)

        XCTAssertEqual(black.luminance, 0.0)
        XCTAssertEqual(almostWhite.luminance, 0.99)
        XCTAssertEqual(almostWhite2.luminance, 0.850)
        XCTAssertEqual(gray.luminance, 0.5)
        XCTAssertEqual(white.luminance, 1.0)
    }

    func testContrastingColor() {
        let black = WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        let gray = WaddaColor(r: 0.5, g: 0.5, b: 0.5, a: 1.0)
        let white = WaddaColor(r: 1, g: 1, b: 1, a: 1.0)
        let almostWhite = WaddaColor(r: 0.9, g: 0.9, b: 0.9, a: 1.0)

        XCTAssertEqual(black.contrastingColor().values, white.values)
        XCTAssertEqual(white.contrastingColor().values, black.values)
        XCTAssertEqual(gray.contrastingColor().values, white.values)
        XCTAssertEqual(almostWhite.contrastingColor().values, black.values)
    }

    func testComplementaryColor() {
        let red = WaddaColor(color: UIColor.redColor())
        let complementary = WaddaColor(r: 0.0, g: 1.0, b: 1.0, a: 1.0)
        XCTAssertEqual(red.complementaryColor().values, complementary.values)

        let black = WaddaColor(color: UIColor.blackColor())
        let complementaryBlack = WaddaColor(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        XCTAssertEqual(black.complementaryColor().values, complementaryBlack.values)

        let white = WaddaColor(color: UIColor.whiteColor())
        let complementarywhite = WaddaColor(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
        XCTAssertEqual(white.complementaryColor().values, complementarywhite.values)
    }
}

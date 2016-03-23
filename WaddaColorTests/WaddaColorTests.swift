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
        let xyz = XYZ(rgb: RGBA(128, 128, 128, 1.0))
        XCTAssertEqualWithAccuracy(xyz.x, 20.518, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(xyz.y, 21.586, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(xyz.z, 23.507, accuracy: 0.001)
    }

    func testXYZtoLAB() {
        let xyz = XYZ(rgb: RGBA(128, 128, 128, 1.0))
        let lab = LAB(xyz: xyz)
        XCTAssertEqualWithAccuracy(lab.l, 53.585, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lab.a, 0.003, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lab.b, -0.006, accuracy: 0.001)
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

        XCTAssertEqualWithAccuracy(black.distanceTo(white), 100.000, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(black.distanceTo(gray), 53.193, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(black.distanceTo(almostBlack), 0.274, accuracy: 0.001)
        XCTAssertEqual(black.distanceTo(black), 0.0)
    }

    func testLuminance() {
        let black = WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        let almostBlack = WaddaColor(r: 1, g: 1, b: 1, a: 1.0)
        let gray = WaddaColor(r: 127, g: 127, b: 127, a: 1.0)
        let white = WaddaColor(r: 255, g: 255, b: 255, a: 1.0)

        XCTAssertEqual(black.luminance, 0.0)
        XCTAssertEqualWithAccuracy(almostBlack.luminance, 0.004, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(gray.luminance, 0.498, accuracy: 0.0001)
        XCTAssertEqual(white.luminance, 1.0)
    }

    func testContrastingColor() {
        let black = WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        let gray = WaddaColor(r: 127, g: 127, b: 127, a: 1.0)
        let white = WaddaColor(r: 255, g: 255, b: 255, a: 1.0)

        XCTAssertEqual(black.contrastingColor(), white)
        XCTAssertEqual(white.contrastingColor(), black)
        XCTAssertEqual(gray.contrastingColor(), white)
    }

    func testComplementaryColor() {
        let red = WaddaColor(color: UIColor.redColor())
        let complementary = WaddaColor(r: 0.0, g: 1.0, b: 1.0, a: 1.0)

        XCTAssertEqual(red.complementaryColor().values, complementary.values)
    }
}

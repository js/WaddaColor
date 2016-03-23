//
//  Colorspaces.swift
//  WaddaColor
//
//  Created by Johan Sørensen on 23/02/16.
//  Copyright © 2016 Johan Sørensen. All rights reserved.
//

import Foundation

public typealias ColorDistance = Double

private func clampedPrecondition(val: Double) {
    precondition(val >= 0.0 && val <= 1.0, "value (\(val) must be betweem 0.0 and 1.0)")
}

public struct RGBA: Equatable, CustomStringConvertible {
    public let r: Double // 0.0-1.0
    public let g: Double
    public let b: Double
    public let a: Double // 0.0-1.0

    public init(_ r: Double, _ g: Double, _ b: Double, _ a: Double) {
        clampedPrecondition(r)
        clampedPrecondition(g)
        clampedPrecondition(b)
        clampedPrecondition(a)

        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    public init(_ r: Int, _ g: Int, _ b: Int, _ a: Double) {
        clampedPrecondition(a)

        self.r = Double(r) / 255.0
        self.g = Double(g) / 255.0
        self.b = Double(b) / 255.0
        self.a = a
    }

    public var color: UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }

    // Returns a value between 0.0 and 100.0, where 100.0 is a perfect match
    public func distanceTo(other: RGBA) -> ColorDistance {
        let xyz1 = XYZ(rgb: self)
        let xyz2 = XYZ(rgb: other)
        let lab1 = LAB(xyz: xyz1)
        let lab2 = LAB(xyz: xyz2)
        return lab1.distance(lab2)
    }

    public var description: String {
        return "<RGBA(r: \(r), g: \(g), b: \(b), a: \(a))>"
    }
}

public func ==(lhs: RGBA, rhs: RGBA) -> Bool {
    return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
}

public struct HSL: CustomStringConvertible {
    public let hue: Double //0-360
    public let saturation: Double // 0-100
    public let lightness: Double // 0-100

    public init(rgb: RGBA) {
        let maximum = max(rgb.r, max(rgb.g, rgb.b))
        let minimum = min(rgb.r, min(rgb.g, rgb.b))
        var h = 0.0
        var s = 0.0
        let l = (maximum + minimum) / 2.0;

        let delta = maximum - minimum
        if delta != 0 {
            if l > 0.5 {
                s = delta / (2.0 - maximum - minimum)
            } else {
                s = delta / (maximum + minimum)
            }
            if maximum == rgb.r {
                h = (rgb.g - rgb.b) / delta + (rgb.g < rgb.b ? 6.0 : 0)
            } else if maximum == rgb.g {
                h = (rgb.b - rgb.r) / delta + 2.0
            } else if maximum == rgb.b {
                h = (rgb.r - rgb.g) / delta + 4.0
            }
            h /= 6.0;
            h *= 3.6;
        }
        self.hue = h * 100.0
        self.saturation = s * 100.0
        self.lightness = l * 100.0
    }

    public func isLight(cutoff: Double = 50) -> Bool {
        return lightness >= cutoff
    }

    public func isDark(cutoff: Double = 50) -> Bool {
        return lightness <= cutoff
    }

    public var description: String {
        return "<HSL(hue: \(hue), saturation: \(saturation), lightness: \(lightness))>"
    }
}

public struct XYZ: CustomStringConvertible {
    public let x: Double
    public let y: Double
    public let z: Double

    public init(rgb: RGBA) {
        var red = rgb.r
        var green = rgb.g
        var blue = rgb.b

        if red > 0.04045 {
            red = (red + 0.055) / 1.055
            red = pow(red, 2.4)
        } else {
            red = red / 12.92
        }

        if green > 0.04045 {
            green = (green + 0.055) / 1.055;
            green = pow(green, 2.4);
        } else {
            green = green / 12.92;
        }

        if blue > 0.04045 {
            blue = (blue + 0.055) / 1.055;
            blue = pow(blue, 2.4);
        } else {
            blue = blue / 12.92;
        }

        red *= 100.0
        green *= 100.0
        blue *= 100.0

        self.x = red * 0.4124 + green * 0.3576 + blue * 0.1805
        self.y = red * 0.2126 + green * 0.7152 + blue * 0.0722
        self.z = red * 0.0193 + green * 0.1192 + blue * 0.9505
    }

    public var description: String {
        return "<XYZ(x: \(x), y: \(y), z: \(z))>"
    }
}


public struct LAB: CustomStringConvertible {
    public let l: Double
    public let a: Double
    public let b: Double

    //    init(l: Double, a: Double, b: Double) {
    //        self.l = l
    //        self.a = a
    //        self.b = b
    //    }

    public init(xyz: XYZ) {
        var x = xyz.x / 95.047
        var y = xyz.y / 100.0
        var z = xyz.z / 108.883

        if x > 0.008856 {
            x = pow(x, 1.0/3.0)
        } else {
            x = 7.787 * x + 16.0 / 116.0
        }

        if y > 0.008856 {
            y = pow(y, 1.0/3.0)
        } else {
            y = (7.787 * y) + (16.0 / 116.0)
        }

        if z > 0.008856 {
            z = pow(z, 1.0/3.0)
        } else {
            z = 7.787 * z + 16.0 / 116.0
        }

        self.l = 116.0 * y - 16.0
        self.a = 500.0 * (x - y)
        self.b = 200.0 * (y - z)
    }

    // CIE1994 distance
    public func distance(other: LAB) -> Double {
        let k1 = 0.045
        let k2 = 0.015

        let C1 = sqrt(a * a + b * b)
        let C2 = sqrt(other.a * other.a + other.b * other.b)

        let deltaA = a - other.a
        let deltaB = b - other.b
        let deltaC = C1 - C2
        let deltaH2 = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC
        let deltaH = (deltaH2 > 0.0) ? sqrt(deltaH2) : 0.0;
        let deltaL = l - other.l;

        let sC = 1.0 + k1 * C1
        let sH = 1.0 + k2 * C1

        let vL = deltaL / 1.0
        let vC = deltaC / (1.0 * sC)
        let vH = deltaH / (1.0 * sH)

        let deltaE = sqrt(vL * vL + vC * vC + vH * vH)
        return deltaE
    }
    
    public var description: String {
        return "<LAB(l: \(l), a: \(a), b: \(b))>"
    }
}

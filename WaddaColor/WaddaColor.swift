//
//  WaddaColor.swift
//  WaddaColor
//
//  Created by Johan Sørensen on 23/02/16.
//  Copyright © 2016 Johan Sørensen. All rights reserved.
//

import UIKit

public extension UIColor {
    var name: String {
        let wadda = WaddaColor(color: self)
        let match = wadda.closestMatch()
        return match.name
    }
}

public struct ColorMatch {
    let name: String
    let values: RGBA
    let distance: ColorDistance
}

public struct WaddaColor: Equatable, CustomStringConvertible {
    public let values: RGBA
    public let colorNames = ColorThesaurusNames()

    public init(color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
    }

    public init(r: Double, g: Double, b: Double, a: Double) {
        self.init(values: RGBA(r, g, b, a))
    }

    public init(values: RGBA) {
        self.values = values
    }

    public var color: UIColor {
        return values.color
    }

    public func closestMatch() -> ColorMatch {
        if let perfectMatch = colorNames.filter({ k, v in v == self.values }).first {
            return ColorMatch(name: perfectMatch.0, values: perfectMatch.1, distance: 1.0)
        }

        // TODO: binary search based on lightness and/or saturation?

        let matches: [ColorMatch] = colorNames.map({ name, color in
            return ColorMatch(name: name, values: color, distance: color.distanceTo(self.values))
        })
        let sortedMatches = matches.sort({ $0.distance < $1.distance })

        return sortedMatches.first!
    }

    // Returns the luma value (0.0-1.0)
    public var luminance: CGFloat {
        // http://en.wikipedia.org/wiki/Luma_(video) Y = 0.2126 R + 0.7152 G + 0.0722 B
        return 0.2126 * CGFloat(values.r) + 0.7152 * CGFloat(values.g) + 0.0722 * CGFloat(values.b)
    }

    public func contrastingColor() -> WaddaColor {
        if luminance > 0.6 {
            return WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        } else {
            return WaddaColor(r: 1, g: 1, b: 1, a: 1.0)
        }
    }

    public func complementaryColor() -> WaddaColor {
        if luminance < 0.1 || luminance > 0.9 {
            return contrastingColor()
        }

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        values.color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let harmonicHue = abs(((hue*360.0) + (180.0/360.0)) % 360.0)

        let color = UIColor(hue: harmonicHue, saturation: saturation, brightness: brightness, alpha: alpha)
        return WaddaColor(color: color)
    }

    public var description: String {
        return "<WaddaColor(values: \(values))>"
    }
}

public func ==(lhs: WaddaColor, rhs: WaddaColor) -> Bool {
    return lhs.values == rhs.values
}

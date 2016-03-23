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

public struct WaddaColor: Equatable {
    let values: RGBA
    public let colorNames = ColorThesaurusNames()

    init(color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(r: Int(red * 255), g: Int(green * 255), b: Int(blue * 255), a: Float(alpha))
    }

    init(r: Int, g: Int, b: Int, a: Float) {
        self.values = RGBA(r, g, b, a)
    }

    func closestMatch() -> ColorMatch {
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
    var luminance: CGFloat {
        // http://en.wikipedia.org/wiki/Luma_(video) Y = 0.2126 R + 0.7152 G + 0.0722 B
        return 0.2126 * CGFloat(values.r) / 255.0 + 0.7152 * CGFloat(values.g) / 255.0 + 0.0722 * CGFloat(values.b) / 255.0
    }

    func contrastingColor() -> WaddaColor {
        if luminance > 0.6 {
            return WaddaColor(r: 0, g: 0, b: 0, a: 1.0)
        } else {
            return WaddaColor(r: 255, g: 255, b: 255, a: 1.0)
        }
    }

    func complementaryColor() -> WaddaColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        values.color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        hue *= 360
        saturation *= 100
        brightness *= 100

        // Pick a complementary color by "rotating" the hue 180 degrees
        hue += 180
        if hue > 360 {
            hue -= 360
        }

        let color = UIColor(hue: round(hue) / 360, saturation: round(saturation) / 100, brightness: round(brightness) / 100, alpha: alpha)
        return WaddaColor(color: color)
    }

    var description: String {
        return "<WaddaColor(values: \(values))>"
    }
}

public func ==(lhs: WaddaColor, rhs: WaddaColor) -> Bool {
    return lhs.values == rhs.values
}

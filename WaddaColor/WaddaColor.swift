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
    let distance: Double
}

public struct WaddaColor {
    let values: RGBA

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
        if let perfectMatch = ColorNames.filter({ k, v in v == self.values }).first {
            return ColorMatch(name: perfectMatch.0, values: perfectMatch.1, distance: 1.0)
        }

        // TODO: binary search based on lightness and/or saturation?

        return ColorMatch(name: "Horse", values: RGBA(0, 0, 0, 1.0), distance: 0.0)
    }
}

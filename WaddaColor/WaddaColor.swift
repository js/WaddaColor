import UIKit

public extension UIColor {
    var name: String {
        let wadda = WaddaColor(color: self)
        return wadda.nameOfClosestMatch()
    }
}

struct RGBA {
    let r: Int // 0-255
    let g: Int
    let b: Int
    let a: Float // 0.0-1.0

    init(_ r: Int, _ g: Int, _ b: Int, _ a: Float) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    var color: UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
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

    func nameOfClosestMatch() -> String {
        return "Horse"
    }
}

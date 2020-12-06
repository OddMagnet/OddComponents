//
//  Angle+Codable.swift
//  OddComponents
//
//  Created by Michael Brünen on 06.12.20.
//

import SwiftUI

extension Angle: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(degrees: try container.decode(Double.self))
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.degrees)
    }
}

extension BlendMode: Codable {
    // TODO: - Codable extension
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
            case "color": self = .color
            case "colorBurn": self = .colorBurn
            case "colorDodge": self = .colorDodge
            case "darken": self = .darken
            case "destinationOut": self = .destinationOut
            case "destinationOver": self = .destinationOver
            case "difference": self = .difference
            case "exclusion": self = .exclusion
            case "hardLight": self = .hardLight
            case "hue": self = .hue
            case "lighten": self = .lighten
            case "luminosity": self = .luminosity
            case "multiply": self = .multiply
            case "overlay": self = .overlay
            case "plusDarker": self = .plusDarker
            case "plusLighter": self = .plusLighter
            case "saturation": self = .saturation
            case "screen": self = .screen
            case "softLight": self = .softLight
            case "sourceAtop": self = .sourceAtop
            default: self = .normal
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        var value = ""
        switch self {
            case .color: value = "color"
            case .colorBurn: value = "colorBurn"
            case .colorDodge: value = "colorDodge"
            case .darken: value = "darken"
            case .destinationOut: value = "destinationOut"
            case .destinationOver: value = "destinationOver"
            case .difference: value = "difference"
            case .exclusion: value = "exclusion"
            case .hardLight: value = "hardLight"
            case .hue: value = "hue"
            case .lighten: value = "lighten"
            case .luminosity: value = "luminosity"
            case .multiply: value = "multiply"
            case .overlay: value = "overlay"
            case .plusDarker: value = "plusDarker"
            case .plusLighter: value = "plusLighter"
            case .saturation: value = "saturation"
            case .screen: value = "screen"
            case .softLight: value = "softLight"
            case .sourceAtop: value = "sourceAtop"
            default: value = "normal"
        }
        try container.encode(value)
    }
}

extension UnitPoint: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
            case "zero": self = .zero
            case "center": self = .center
            case "leading": self = .leading
            case "trailing": self = .trailing
            case "top": self = .top
            case "bottom": self = .bottom
            case "topLeading": self = .topLeading
            case "topTrailing": self = .topTrailing
            case "bottomLeading": self = .bottomLeading
            case "bottomTrailing": self = .bottomTrailing
            case "": self.init()
            case let x_y:
                let f = NumberFormatter()
                let str = x_y.components(separatedBy: "x")
                guard let x = f.number(from: str[0]) else { fatalError() }
                guard let y = f.number(from: str[1]) else { fatalError() }
                self.init(x: CGFloat(truncating: x), y: CGFloat(truncating: y))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .zero: try container.encode("zero")
            case .center: try container.encode("center")
            case .leading: try container.encode("leading")
            case .trailing: try container.encode("trailing")
            case .top: try container.encode("top")
            case .bottom: try container.encode("bottom")
            case .topLeading: try container.encode("topLeading")
            case .topTrailing: try container.encode("topTrailing")
            case .bottomLeading: try container.encode("bottomLeading")
            case .bottomTrailing: try container.encode("bottomTrailing")
            default:
                if x == 0 && y == 0 { try container.encode("") }
                else { try container.encode("\(x)x\(y)") }
        }
    }
}

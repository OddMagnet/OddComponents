//
//  DataPoint.swift
//  OddComponents
//
//  Created by Michael Brünen on 25.03.21.
//

import SwiftUI

struct DataPoint: Identifiable {
    let id: Int
    let value: Double
    let color: Color
    let title: String

    // random ID, useful if DataPoints don't change
    init(value: Double, color: Color? = nil, title: String = "") {
        self.id = Int.random(in: 1..<Int.max)
        self.value = value
        if let color = color { self.color = color } else { self.color = Color.random() }
        self.title = title
    }

    // fixed ID
    init(id: Int, value: Double, color: Color? = nil, title: String = "") {
        self.id = id
        self.value = value
        if let color = color { self.color = color } else { self.color = Color.random() }
        self.title = title
    }
}

extension Color {
    static func random() -> Color {
        Color(
            UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        )
    }
}

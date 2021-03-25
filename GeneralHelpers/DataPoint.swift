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
    init(value: Double, color: Color, title: String = "") {
        self.id = Int.random(in: 1..<Int.max)
        self.value = value
        self.color = color
        self.title = title
    }

    // fixed ID
    init(id: Int, value: Double, color: Color, title: String = "") {
        self.id = id
        self.value = value
        self.color = color
        self.title = title
    }
}

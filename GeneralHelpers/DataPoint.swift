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

    // random ID, useful if DataPoints don't change
    init(value: Double, color: Color) {
        self.id = Int.random(in: 1..<Int.max)
        self.value = value
        self.color = color
    }

    // fixed ID
    init(id: Int, value: Double, color: Color) {
        self.id = id
        self.value = value
        self.color = color
    }
}

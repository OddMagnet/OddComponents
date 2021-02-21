//
//  View+ForegroundMask.swift
//  OddComponents
//
//  Created by Michael Brünen on 21.02.21.
//

import SwiftUI

extension View {
    public func foregroundMask<Content: View>(_ overlay: Content) -> some View {
        self
            .overlay(overlay)
            .mask(self)
    }
}

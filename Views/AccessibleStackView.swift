//
//  AccessibleStackView.swift
//  OddComponents
//
//  Created by Michael Brünen on 11.02.21.
//

import SwiftUI

struct AccessibleStack<Content: View>: View {
    @Environment(\.sizeCategory) var size
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var spacing: CGFloat?
    var horizontalAlignment: HorizontalAlignment
    var verticalAlignment: VerticalAlignment
    var verticalStartSize: ContentSizeCategory
    let content: () -> Content

    // custom initialiser in order to use @ViewBuilder for `content`
    init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        verticalStartSize: ContentSizeCategory = .accessibilityMedium,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.verticalStartSize = verticalStartSize
        self.content = content
    }

    var body: some View {
        if size >= verticalStartSize || verticalSizeClass == .compact {
            VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
        } else {
            HStack(alignment: verticalAlignment, spacing: spacing, content: content)
        }
    }
}

struct AccessibleStackDemo: View {
    var body: some View {
        AccessibleStack(spacing: 10) {
            Text("If the font-size is small, this will be")
            Text("horizontal, otherwise it will be vertical")
        }
    }
}

struct AccessibleStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        AccessibleStackDemo()
            .environment(\.sizeCategory, .accessibilityMedium)
    }
}

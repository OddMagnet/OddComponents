//
//  LongPressButtonView.swift
//  OddComponents
//
//  Created by Michael Brünen on 24.01.21.
//

import SwiftUI

/// A customizable LongPressButton
struct LongPressButtonView<Content: View>: View {
    var content: Content
    var backgroundColor: Color = .clear
    var foregroundColor: Color = .primary
    var strokeColor: Color = .black
    var strokeWidth: CGFloat = 4
    var strokeLineCap: CGLineCap = .round
    var buttonFont: Font = Font.title
    var backgroundShape: some Shape = Circle()
    var minimumDuration: Double = 1.5
    var buttonAnimation: Animation = .linear
    var action: () -> Void

    @State private var feedback = UINotificationFeedbackGenerator()
    @GestureState private var isPressed = false

    var body: some View {
        content
            .font(buttonFont)
            .foregroundColor(foregroundColor)
            .accessibility(addTraits: .isButton)            // this should show as a button
            .accessibility(removeTraits: .isImage)          // and not an image in accessibility
            .padding()
            .background(
                backgroundShape
                    .fill(backgroundColor)
            )
            .overlay(
                backgroundShape
                    .rotation(.init(degrees: -90))          // ensure progress starts from the top
                    .trim(from: 0, to: isPressed ? 1 : 0)   // works togther with .animation further down
                    .stroke(
                        strokeColor,
                        style: StrokeStyle(
                            lineWidth: strokeWidth,
                            lineCap: strokeLineCap
                        )
                    )
            )
            .gesture(
                LongPressGesture(minimumDuration: minimumDuration)
                    .updating($isPressed) { new, existing, _ in
                        existing = new
                    }
                    .onEnded { _ in
                        feedback.notificationOccurred(.success)
                        action()
                    }
            )
            .animation(buttonAnimation)
    }
}

struct LongPressButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButtonView(
            content: Image(systemName: "star.fill"),
            action: { print("Hello action") }
        )
    }
}

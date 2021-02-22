//
//  AnimatedButton.swift
//  OddComponents
//
//  Created by Michael Brünen on 22.02.21.
//

import SwiftUI

struct PulsatingButtonStyle: AnimatingButtonStyle {
    let backgroundColor: Color = .blue
    let foregroundColor: Color = .white
    let strokeColor: Color = .blue
    let animation: Double

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .clipShape(Circle())
            .foregroundColor(foregroundColor)
            .padding(4)
            .overlay(
                Circle()
                    .stroke(strokeColor, lineWidth: 2)
                    .scaleEffect(CGFloat(1 + animation))
                    .opacity(1 - animation)
            )
    }
}

struct SpinningArcButtonStyle: AnimatingButtonStyle {
    let animation: Double

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .clipShape(Circle())
            .foregroundColor(.white)
            .padding(4)
            .overlay(
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.blue, lineWidth: 4)
                    .rotationEffect(.init(degrees: -animation * 360))
            )
            .padding(6)
            .overlay(
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.blue, lineWidth: 4)
                    .rotationEffect(.init(degrees: animation * 360))
            )
    }
}

struct AnimatedButton<ButtonStyle: AnimatingButtonStyle, Content: View>: View {
    let buttonStyle: ButtonStyle.Type
    let animation: Animation
    var animationSpeed: Double = 5.0
    let autoreverse: Bool = false
    let action: () -> Void
    let label: () -> Content

    @State private var animationState = 0.0

    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(buttonStyle.init(animation: animationState))
            .onAppear {
                withAnimation(animation.repeatForever(autoreverses: autoreverse)) {
                    animationState = 1
                }
            }
    }
}

struct AnimatedButtonDemoView: View {
    var body: some View {
        VStack {
            Spacer()

            AnimatedButton(
                buttonStyle: PulsatingButtonStyle.self,
                animation: .easeOut(duration: 1),
                animationSpeed: 1
            ) {
                print("Pressed the animated pulsating button")
            } label:  {
                Image(systemName: "star")
            }

            Spacer()

            AnimatedButton(
                buttonStyle: SpinningArcButtonStyle.self,
                animation: .easeOut(duration: 1),
                animationSpeed: 1
            ) {
                print("Pressed the animated spinning arc button")
            } label: {
                Image(systemName: "star")
            }

            Spacer()
        }
    }
}


struct AnimatedButton_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedButtonDemoView()
    }
}

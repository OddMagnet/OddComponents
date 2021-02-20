//
//  ButtonStyles.swift
//  OddComponents
//
//  Created by Michael Brünen on 20.02.21.
//

import SwiftUI

struct ColoredButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical)
            .padding(.horizontal, 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundColor(.white)
            .overlay(
                Color.black
                    .opacity(configuration.isPressed ? 0.3 : 0)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
    }
}

struct StripedRectangleButtonStyle: ButtonStyle {
    var offColor = Color.blue
    var onColor = Color.green

    func color(for configuration: Configuration) -> Color {
        configuration.isPressed ? onColor : offColor
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Rectangle()
                .fill(color(for: configuration))
                .frame(width: 10)

            configuration.label
                .padding()
                .foregroundColor(color(for: configuration))
                .textCase(.uppercase)
                .font(Font.title.bold())
                .border(color(for: configuration), width: 4)
        }
        .fixedSize()
        .animation(nil)
    }
}

struct PushButtonStyle: ButtonStyle {
    let lightGray = Color(white: 0.8)

    func makeBody(configuration: Configuration) -> some View {
        let startEdge: UnitPoint
        let endEdge: UnitPoint

        if configuration.isPressed {
            startEdge = .bottomTrailing
            endEdge = .topLeading
        } else {
            startEdge = .topLeading
            endEdge = .bottomTrailing
        }

        return configuration.label
            .foregroundColor(Color.black.opacity(configuration.isPressed ? 0.7 : 1))
            .font(.largeTitle)
            .padding(40)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, lightGray]),
                               startPoint: startEdge,
                               endPoint: endEdge)
            )
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.white, lightGray]),
                                       startPoint: startEdge,
                                       endPoint: endEdge),
                        lineWidth: 16
                    )
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(configuration.isPressed ? Color.black : Color.gray, lineWidth: 4)
                    )
            )
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 10, x: 10, y: 10)
            .animation(nil)
    }
}

struct GlassButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .font(Font.largeTitle.bold())
                .foregroundColor(color)
                .offset(x: -1, y: -1)

            configuration.label
                .font(Font.largeTitle.bold())
                .foregroundColor(.white)
        }
        .padding()
        .background(
            color
                .opacity(configuration.isPressed ? 0.9 : 1)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color.white.opacity(0.6), location: 0),
                            Gradient.Stop(color: Color.white.opacity(0.15), location: 0.499),
                            Gradient.Stop(color: Color.white.opacity(0), location: 0.5),
                            Gradient.Stop(color: Color.white.opacity(0), location: 0.8),
                            Gradient.Stop(color: Color.white.opacity(0.2), location: 1)
                        ]),
                        startPoint: .top, endPoint: .bottom)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(Color.white.opacity(0.4), lineWidth: 1)
                )

        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .scaleEffect(configuration.isPressed ? 0.99 : 1)
    }
}

struct ButtonStylesDemoView: View {
    var body: some View {
        VStack {
            Text("Show me what you got")

            Button("Colored Button") {
                print("Pressed the colored button")
            }
            .buttonStyle(ColoredButtonStyle(color: .green))

            Button("Striped Rectangle") {
                print("Pressed the striped rectangle button")
            }
            .buttonStyle(StripedRectangleButtonStyle())

            Button("Push") {
                print("Pressed the push button")
            }
            .buttonStyle(PushButtonStyle())

            Button("Glass Style") {
                print("Pressed the glass style button")
            }
            .buttonStyle(GlassButtonStyle(color: .classicGreen))
        }
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStylesDemoView()
    }
}

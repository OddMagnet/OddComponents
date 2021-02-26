//
//  ButtonStyles.swift
//  OddComponents
//
//  Created by Michael Brünen on 20.02.21.
//

import SwiftUI
import Combine

// MARK: - Basic styles
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

// MARK: - Intermediate styles
struct AquaButtonStyle: ButtonStyle {
    let background = Color(red: 0.3, green: 0.6, blue: 1)
    let highLight = Color(red: 0.7, green: 1, blue: 1)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .padding(.horizontal, 20)
            .background(
                ZStack {
                    // Background color
                    background

                    // white capsule shaped gradient at the top, slightly squished
                    Capsule()
                        .inset(by: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]),
                                startPoint: .top, endPoint: UnitPoint(x: 0.5, y: 0.8)
                            )
                        )
                        .scaleEffect(x: 0.95, y: 0.7, anchor: .top)

                    // highlight capsule shaped gradient at the bottom, more squished and blurred
                    Capsule()
                        .inset(by: 8)
                        .offset(y: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [highLight.opacity(0), highLight]),
                                startPoint: .top, endPoint: UnitPoint(x: 0.5, y: 0.8)
                            )
                        )
                        .scaleEffect(y: 0.7, anchor: .bottom)
                        .blur(radius: 10)

                    if configuration.isPressed {
                        Color.blue.opacity(0.2)
                    }
                }
            )
            .clipShape(Capsule())
            .overlay(
                // Border
                Capsule()
                    .strokeBorder(Color.black.opacity(0.25), lineWidth: 1)
            )
    }
}

struct FantasyButtonStyle: ButtonStyle {    // Inspired by the game 'Age of Empires'
    // Foreground gradient for the text
    var foregroundGradientStart = Color(red: 1, green: 0.85, blue: 0.85)
    var foregroundGradientEnd = Color(red: 1, green: 0.65, blue: 0.3)
    private var foregroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [foregroundGradientStart, foregroundGradientEnd]),
            startPoint: .top,
            endPoint: .bottom)
    }

    // Background gradient where the sides are darker than the middle
    var backgroundGradientStart = Color(red: 0.33, green: 0.06, blue: 0.04)
    var backgroundGradientEnd = Color(red: 0.5, green: 0.1, blue: 0.1)
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: backgroundGradientStart, location: 0),
                .init(color: backgroundGradientEnd, location: 0.3),
                .init(color: backgroundGradientEnd, location: 0.7),
                .init(color: backgroundGradientStart, location: 1)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var rimGradientStart = Color(red: 0.725, green: 0.55, blue: 0.3)
    var rimGradientEnd = Color(red: 0.2, green: 0.13, blue: 0.05)
    private var rimGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: rimGradientStart, location: 0),
                .init(color: rimGradientStart, location: 0.49),
                .init(color: rimGradientEnd, location: 0.51),
                .init(color: rimGradientEnd, location: 1)
            ]),
            startPoint: UnitPoint(x: 0.47, y: 0),
            endPoint: UnitPoint(x: 0.53, y: 1)
        )
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            // Text
            .foregroundMask(foregroundGradient) // the gradient is masked by the buttons text
            .font(Font.system(.largeTitle, design: .serif).lowercaseSmallCaps())
            .shadow(color: .black, radius: 5, x: 3, y: 3)
            // Background
            .padding()
            .background(
                ZStack {
                    backgroundGradient

                    if configuration.isPressed {
                        Color.black.opacity(0.3)
                    }
                }
            )
            // Inner shadow, blurred stroke where the outsides are mask by another Rectangle
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 8)
                    .blur(radius: 8)
                    .mask(Rectangle())
            )
            // Rim gradient
            .overlay(
                Rectangle()
                    .strokeBorder(rimGradientStart, lineWidth: 1)
                    .padding(2)
                    .overlay(
                        Rectangle()
                            .strokeBorder(rimGradient, lineWidth: 2)
                    )
            )
    }
}

struct SciFiTargetButtonStyle: ButtonStyle {
    let strokeColor: Color = .white
    let glowColor: Color = .blue
    let glowIntensity: CGFloat = 5

    func circle(with configuration: Configuration) -> some View {
        Circle()
            .trim(from: 0.05, to: 0.2)
            .stroke(strokeColor, lineWidth: 5)
            .shadow(color: glowColor, radius: glowIntensity)
            .shadow(color: glowColor, radius: glowIntensity)
            .shadow(color: glowColor, radius: glowIntensity)
            .scaleEffect(configuration.isPressed ? 0.6 : 0.8)
    }

    func tick(with configuration: Configuration) -> some View {
        Circle()
            .trim(from: 0.24, to: 0.26)
            .stroke(strokeColor, lineWidth: 20)
            .shadow(color: glowColor, radius: glowIntensity)
            .shadow(color: glowColor, radius: glowIntensity)
            .shadow(color: glowColor, radius: glowIntensity)
            .scaleEffect(configuration.isPressed ? 0.6 : 0.8)
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .foregroundColor(.white)
            // Background gradient
            .padding(40)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0)]),
                    center: .center,
                    startRadius: 0, endRadius: 50
                )
                .opacity(configuration.isPressed ? 0.8 : 1)
            )
            // Target circle segments
            .overlay(circle(with: configuration))
            .overlay(circle(with: configuration).rotationEffect(.init(degrees: 90)))
            .overlay(circle(with: configuration).rotationEffect(.init(degrees: 180)))
            .overlay(circle(with: configuration).rotationEffect(.init(degrees: 270)))
            // Target circle ticks
            .overlay(tick(with: configuration))
            .overlay(tick(with: configuration).rotationEffect(.init(degrees: 90)))
            .overlay(tick(with: configuration).rotationEffect(.init(degrees: 180)))
            .overlay(tick(with: configuration).rotationEffect(.init(degrees: 270)))
    }
}

// MARK: - Advanced styles
// Different from the normal `ButtonStyle` protocol, `PrimitiveButtonStyle`
// does not provide the button functionality, enabling completely custom behaviours
#if DEBUG
typealias CustomButtonType = DebugButtonStyle
#else
typealias CustomButtonType = DefaultButtonStyle
#endif
struct DebugButtonStyle: PrimitiveButtonStyle {
    let location: String

    func makeBody(configuration: Configuration) -> some View {
        Button {
            print("Pressed button on location: \(location)")
            configuration.trigger()
        } label: {
            HStack {
                Text("Debug: ")
                configuration.label
            }
        }
        .buttonStyle(DefaultButtonStyle())
    }

    // Setting the location to whatever the current file and line is that the buttons stems from
    init(file: String = #file, line: Int = #line) {
        location = "\(line) in \(file)"
    }
}

struct CancellableButtonStyle: PrimitiveButtonStyle {
    private struct CancellableButton: View {
        let configuration: Configuration
        let timeOut: Double

        @State private var timerSubscription: Cancellable?
        @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common)
        @State private var countDown = 0.0

        var body: some View {
            if timerSubscription == nil {
                startButton
            } else {
                cancelButton
                    .onReceive(timer) { _ in
                        if countDown > 0.01 {
                            countDown -= 0.01
                        } else {
                            configuration.trigger()
                            cancelTimer()
                        }
                    }
            }
        }

        var startButton: some View {
            Button {
                timer = Timer.publish(every: 0.01, on: .main, in: .common)
                timerSubscription = timer.connect()
                countDown = timeOut
            } label: {
                configuration.label
            }
        }

        var cancelButton: some View {
            Button {
                cancelTimer()
            } label: {
                Text("\(countDown, specifier: "%.2f")")
            }
        }

        func cancelTimer() {
            timerSubscription?.cancel()
            timerSubscription = nil
        }
    }

    var timeOut: Double = 3.0

    func makeBody(configuration: Configuration) -> some View {
        CancellableButton(configuration: configuration, timeOut: timeOut)
    }
}

struct ButtonStylesDemoView: View {
    var body: some View {
        VStack {
            Spacer()

            Text("Basic Button Styles")
                .font(.title)
            HStack(spacing: 20) {
                Button("x") {
                    print("Pressed the colored button")
                }
                .buttonStyle(ColoredButtonStyle(color: .green))

                Button("x") {
                    print("Pressed the striped rectangle button")
                }
                .buttonStyle(StripedRectangleButtonStyle())

                Button("x") {
                    print("Pressed the push button")
                }
                .buttonStyle(PushButtonStyle())

                Button("x") {
                    print("Pressed the glass style button")
                }
                .buttonStyle(GlassButtonStyle(color: .classicRed))
            }

            Spacer()

            Text("Intermediate Button Styles")
                .font(.title)
            HStack(spacing: 20) {
                Button("x") {
                    print("Pressed the aqua style button")
                }
                .buttonStyle(AquaButtonStyle())

                Button("x") {
                    print("Pressed the fantasy style button")
                }
                .buttonStyle(FantasyButtonStyle())
                .frame(width: 50)

                Button {
                    print("Pressed the scifi style button")
                } label: {
                    Image(systemName: "star")
                }
                .buttonStyle(SciFiTargetButtonStyle())
                .background(Color.black)
            }

            Spacer()

            Text("Advanced Button Styles")
                .font(.title)
            HStack(spacing: 20) {
                Button("x") {
                    print("Pressed the debugging style button")
                }
                .buttonStyle(CustomButtonType())

                Button("x.xx") {
                    print("Pressed the cancellable style button")
                }
                .frame(width: 35)
                .buttonStyle(CancellableButtonStyle())
            }

            Spacer()
        }
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStylesDemoView()
    }
}

//
//  ParticleView.swift
//  OddComponents
//
//  Created by Michael Brünen on 04.12.20.
//

import SwiftUI

enum ParticleMode {
    case confetti, explosion, fireflies, magic, rain, smoke, snow

    static func configFor(mode: ParticleMode) -> ParticleConfig {
        switch mode {
            case .confetti:
                return ParticleConfig(
                    particleType: .confetti, particleCount: 50,
                    animation: Animation.linear(duration: 5).repeatForever(autoreverses: false),
                    animationDelayThreshold: 5,
                    colors: [.red, .yellow, .blue, .green, .white, .orange, .purple],
                    creationPoint: .init(x: 0.5, y: -0.1), creationRange: .init(width: 1, height: 0),
                    angle: .degrees(180), angleRange: .radians(.pi / 4),
                    speed: 1200, speedRange: 800,
                    scale: 0.6,
                    rotationRange: .radians(.pi * 2), rotationSpeed: .radians(.pi)
                )
            case .explosion:
                return ParticleConfig(
                    particleType: .spark, particleCount: 500,
                    animation: Animation.easeOut(duration: 1).repeatForever(autoreverses: false),
                    colors: [.red], blendMode: .screen,
                    angleRange: .degrees(360),
                    speed: 60, speedRange: 80,
                    opacitySpeed: -1,
                    scale: 0.4, scaleRange: 0.1, scaleSpeed: 0.3
                )
            case .fireflies:
                return ParticleConfig(
                    particleType: .spark, particleCount: 100,
                    animation: Animation.easeInOut(duration: 1).repeatForever(autoreverses: false),
                    animationDelayThreshold: 1,
                    colors: [.yellow, .orange], blendMode: .screen,
                    creationRange: .init(width: 1, height: 1),
                    angleRange: .degrees(360),
                    speed: 120, speedRange: 120,
                    opacitySpeed: -1,
                    scale: 0.5, scaleRange: 0.2, scaleSpeed: -0.2
                )
            case .magic:
                return ParticleConfig(
                    particleType: .spark, particleCount: 200,
                    animation: Animation.easeOut(duration: 1).repeatForever(autoreverses: false),
                    animationDelayThreshold: 1,
                    colors: [Color(red: 0.5, green: 1, blue: 1)], blendMode: .screen,
                    angleRange: .degrees(360),
                    speed: 120, speedRange: 120,
                    opacitySpeed: -1,
                    scale: 0.5, scaleRange: 0.2, scaleSpeed: -0.2
                )
            case .rain:
                return ParticleConfig(
                    particleType: .line, particleCount: 100,
                    animation: Animation.linear(duration: 1).repeatForever(autoreverses: false),
                    animationDelayThreshold: 1,
                    colors: [Color(red: 0.8, green: 0.8, blue: 1)],
                    creationPoint: .init(x: 0.5, y: -0.1), creationRange: .init(width: 1, height: 0),
                    angle: .degrees(180),
                    speed: 1000, speedRange: 400,
                    opacityRange: 1,
                    scale: 0.6
                )
            case .smoke:
                return ParticleConfig(
                    particleType: .spark, particleCount: 200,
                    animation: Animation.linear(duration: 3).repeatForever(autoreverses: false),
                    animationDelayThreshold: 3,
                    colors: [.gray], blendMode: .screen,
                    angleRange: .degrees(90),
                    speed: 100, speedRange: 80,
                    opacitySpeed: -1,
                    scale: 0.3, scaleRange: 0.1, scaleSpeed: 1
                )
            case .snow:
                return ParticleConfig(
                    particleType: .spark, particleCount: 100,
                    animation: Animation.linear(duration: 10).repeatForever(autoreverses: false),
                    animationDelayThreshold: 10,
                    colors: [.white],
                    creationPoint: .init(x: 0.5, y: -0.1), creationRange: .init(width: 1, height: 0),
                    angle: .degrees(180), angleRange: .degrees(10),
                    speed: 2000, speedRange: 1500,
                    opacityRange: 1,
                    scale: 0.4, scaleRange: 0.4
                )
        }
    }
}

struct ParticleView: View {
    private struct Particle: View {
        @State var isActive: Bool = false
        let type: ParticleType
        let position: ParticleState<CGPoint>
        let scale: ParticleState<CGFloat>
        let opacity: ParticleState<Double>
        let rotation: ParticleState<Angle>

        var body: some View {
            Image(type.rawValue)
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .rotationEffect(isActive ? rotation.end : rotation.start)
                .position(isActive ? position.end : position.start)
                .onAppear { isActive = true }
        }
    }

    private var count: Int
    private var type: ParticleType
    private var position: (GeometryProxy) -> ParticleState<CGPoint>
    private var scale: ParticleState<CGFloat>
    private var opacity: ParticleState<Double>
    private var rotation: ParticleState<Angle>
    private var animation: Animation
    private var animationDelayThreshold: Double
    private var colors: [Color]
    private var blendMode: BlendMode

    init(config: ParticleConfig) {
        count = config.particleCount
        type = config.particleType
        position = config.position(in:)
        scale = config.makeScale()
        opacity = config.makeOpacity()
        rotation = config.makeRotation()
        animation = config.animation
        animationDelayThreshold = config.animationDelayThreshold
        colors = config.colors
        blendMode = config.blendMode
    }

    init(mode: ParticleMode) {
        self.init(config: ParticleMode.configFor(mode: mode))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0 ..< count, id: \.self) { i in
                    Particle(
                        type: type,
                        position: position(geometry),
                        scale: scale,
                        opacity: opacity,
                        rotation: rotation
                    )
                    .animation(animation.delay(Double.random(in: 0...animationDelayThreshold)))
                    .colorMultiply(colors.randomElement() ?? .white)
                    .blendMode(blendMode)
                }
            }
        }
    }
}

struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ParticleView(mode: .snow)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

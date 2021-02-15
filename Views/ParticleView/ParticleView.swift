//
//  ParticleView.swift
//  OddComponents
//
//  Created by Michael Brünen on 04.12.20.
//

import SwiftUI

enum ParticleMode: String, CaseIterable {
    case confetti, explosion, fireflies, magic, rain, smoke, snow

    static func animationFor(_ mode: ParticleMode) -> Animation {
        switch mode {
            case .confetti: return Animation.linear(duration: 5).repeatForever(autoreverses: false)
            case .explosion: return Animation.easeOut(duration: 1).repeatForever(autoreverses: false)
            case .fireflies: return Animation.easeInOut(duration: 1).repeatForever(autoreverses: false)
            case .magic: return Animation.easeOut(duration: 1).repeatForever(autoreverses: false)
            case .rain: return Animation.linear(duration: 1).repeatForever(autoreverses: false)
            case .smoke: return Animation.linear(duration: 3).repeatForever(autoreverses: false)
            case .snow: return Animation.linear(duration: 10).repeatForever(autoreverses: false)
        }
    }

    static func colorsFor(_ mode: ParticleMode) -> [Color] {
        switch mode {
            case .confetti: return [.red, .yellow, .blue, .green, .white, .orange, .purple]
            case .explosion: return [.red]
            case .fireflies: return [.yellow, .orange]
            case .magic: return [Color(red: 0.5, green: 1, blue: 1)]
            case .rain: return [Color(red: 0.8, green: 0.8, blue: 1)]
            case .smoke: return [.gray]
            case .snow: return [.white]
        }
    }

    static func configFor(_ mode: ParticleMode) -> ParticleConfig {
        return ParticleConfig.load(from: "\(mode.rawValue).json")
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

    init(config: ParticleConfig, animation: Animation, colors: [Color]) {
        count = config.particleCount
        type = config.particleType
        position = config.position(in:)
        scale = config.makeScale()
        opacity = config.makeOpacity()
        rotation = config.makeRotation()
        self.animation = animation
        animationDelayThreshold = config.animationDelayThreshold
        self.colors = colors
        blendMode = config.blendMode
    }

    init(mode: ParticleMode) {
        self.init(
            config: ParticleMode.configFor(mode),
            animation: ParticleMode.animationFor(mode),
            colors: ParticleMode.colorsFor(mode)
        )
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
        VStack {
            ParticleView(mode: .rain)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

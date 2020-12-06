//
//  ParticleConfig.swift
//  OddComponents
//
//  Created by Michael Brünen on 06.12.20.
//

import SwiftUI

struct ParticleState<T: Codable>: Codable {
    var start: T
    var end: T

    init(_ start: T, _ end: T) {
        self.start = start
        self.end = end
    }
}

enum ParticleType: String, CaseIterable, Codable {
    case spark
    case line
    case confetti
    case random
}

struct ParticleConfig: Codable {
    static func load(from file: String) -> ParticleConfig {
        return Bundle.main.decode(ParticleConfig.self, from: file)
    }
    // General
    var particleType: ParticleType
    private var type: ParticleType {
        switch particleType {
            case .random:
                return ParticleType.allCases.randomElement()!
            default:
                return particleType
        }
    }
    var particleCount: Int
    var animationDelayThreshold: Double
    var blendMode: BlendMode

    // Movement
    var creationPoint: UnitPoint
    var creationRange: CGSize
    var angle: Angle
    var angleRange: Angle
    var speed: Double
    var speedRange: Double

    // Scale and opacity
    var opacity: Double
    var opacityRange: Double
    var opacitySpeed: Double
    var scale: CGFloat
    var scaleRange: CGFloat
    var scaleSpeed: CGFloat

    // Spinning and Blending
    var rotation: Angle
    var rotationRange: Angle
    var rotationSpeed: Angle

    init(
        particleType: ParticleType, particleCount: Int,
        animationDelayThreshold: Double = 1.0,
        blendMode: BlendMode = .normal,
        creationPoint: UnitPoint = .center, creationRange: CGSize = .zero,
        angle: Angle = .zero, angleRange: Angle = .zero,
        speed: Double = 50.0, speedRange: Double = 0.0,
        opacity: Double = 1.0, opacityRange: Double = 0.0, opacitySpeed: Double = 0.0,
        scale: CGFloat = 1, scaleRange: CGFloat = 0, scaleSpeed: CGFloat = 0,
        rotation: Angle = .zero, rotationRange: Angle = .zero, rotationSpeed: Angle = .zero
    ) {
        self.particleType = particleType
        self.particleCount = particleCount
        self.animationDelayThreshold = animationDelayThreshold
        self.blendMode = blendMode
        // Movement
        self.creationPoint = creationPoint
        self.creationRange = creationRange
        self.angle = angle
        self.angleRange = angleRange
        self.speed = speed
        self.speedRange = speedRange
        // Scale and opacity
        self.opacity = opacity
        self.opacityRange = opacityRange
        self.opacitySpeed = opacitySpeed
        self.scale = scale
        self.scaleRange = scaleRange
        self.scaleSpeed = scaleSpeed
        // Spinning and Blending
        self.rotation = rotation
        self.rotationRange = rotationRange
        self.rotationSpeed = rotationSpeed
    }

    func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        // range of x/y variance a particle can have
        let halfCreationRangeWidth = creationRange.width / 2
        let halfCreationRangeHeight = creationRange.height / 2

        // generate random offsets
        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
        let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeHeight)

        // calculate start point
        let startX = Double(proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = Double(proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)

        // generate a random speed and angle for the particle
        let halfSpeedRange = speedRange / 2
        let actualSpeed  = speed + Double.random(in: -halfSpeedRange...halfSpeedRange)
        let halfAngleRange = angleRange.radians / 2
        let actualDirection = angle.radians + Double.random(in: -halfAngleRange...halfAngleRange)

        // calculate end point
        let endX = cos(actualDirection - .pi / 2) * actualSpeed
        let endY = sin(actualDirection - .pi / 2) * actualSpeed
        let end = CGPoint(x: startX + endX, y: startY + endY)

        return ParticleState(start, end)
    }

    func makeOpacity() -> ParticleState<Double> {
        let halfOpacityRange = opacityRange / 2
        let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
        return ParticleState(opacity + randomOpacity, opacity + opacitySpeed + randomOpacity)
    }

    func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }

    func makeRotation() -> ParticleState<Angle> {
        let halfRotationRange = (rotationRange / 2).radians
        let randomRotation = Double.random(in: -halfRotationRange...halfRotationRange)
        let randomRotationAngle = Angle(radians: randomRotation)
        return ParticleState(rotation + randomRotationAngle, rotation + rotationSpeed + randomRotationAngle)
    }
}

//
//  ParticleView.swift
//  OddComponents
//
//  Created by Michael Brünen on 04.12.20.
//

import SwiftUI

struct ParticleView: View {
    private struct ParticleState<T> {
        var start: T
        var end: T

        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }
    private struct Particle: View {
        @State var isActive: Bool = false
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let scale: ParticleState<CGFloat>

        var body: some View {
            Image("spark")
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .position(isActive ? position.end : position.start)
                .onAppear { isActive = true }
        }
    }

    var particleCount: Int
    var creationPoint = UnitPoint.center
    var creationRange = CGSize.zero
    var angle = Angle.zero
    var angleRange = Angle.zero
    var duration = 1.0
    var opacity = 1.0
    var opacityRange = 0.0
    var opacitySpeed = 0.0
    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0
    var speed = 50.0
    var speedRange = 0.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0 ..< particleCount, id: \.self) { i in
                    Particle(position: self.position(in: geometry),
                             opacity: self.makeOpacity(),
                             scale: self.makeScale()
                    )
                        .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false))
                }
            }
        }
    }

    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
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

    private func makeOpacity() -> ParticleState<Double> {
        let halfOpacityRange = opacityRange / 2
        let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
        return ParticleState(opacity + randomOpacity, opacity + opacitySpeed + randomOpacity)
    }

    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }

}

struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ParticleView(particleCount: 20,
                        angleRange: .degrees(360),
                        duration: 1.5,
                        opacitySpeed: -1,
                        scale: 0.4,
                        scaleRange: 0.1,
                        scaleSpeed: 0.4,
                        speed: 100,
                        speedRange: 80)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

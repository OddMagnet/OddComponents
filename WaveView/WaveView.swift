//
//  WaveView.swift
//  OddComponents
//
//  Created by Michael Brünen on 03.12.20.
//

import SwiftUI

fileprivate extension UIBezierPath {
    func moveTo(x: Double, y: Double) {
        self.move(to: CGPoint(x: x, y: y))
    }
    func addLineTo(x: Double, y: Double) {
        self.addLine(to: CGPoint(x: x, y: y))
    }
}

fileprivate struct Wave: Shape {
    /// Height of the waves
    var strength: Double

    /// Frequency of the waves
    var frequency: Double

    /// Horizontal offset of the wave
    var phase: Double

    /// How smooth the waves are drawn, lower is better, value must be between 1 and `frequency`
    var precision: Double = 1

    // allow SwiftUI to animate the wave phase
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }

    private var clampedPrecision: Double {
        precision < 1
            ? 1
            : precision > frequency
            ? frequency
            : precision
    }

    /// Returns the path for the WaveView
    /// - Parameter rect: The rectangle which contains the WaveView
    /// - Returns: The path for the WaveView
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let widthNormalizer = 1 / midWidth

        // calculate the length of a single wave
        let wavelength = width / frequency

        // start drawing the path
        path.moveTo(x: 0, y: midHeight)
        for x in stride(from: 0, through: width, by: clampedPrecision) {
            // calculate the position for the next point ...
            let relativeX = x / wavelength
            // ... distance to the middle ...
            let distanceToMidWith = x - midWidth
            // .. normalize it to a value between -1 and 1 ...
            let normalizedDistance = widthNormalizer * distanceToMidWith
            // ... bring it into a range of 0..1..0, big wave in the middle, small on the sides ...
            let parabola = -(normalizedDistance * normalizedDistance) + 1
            // ... calculate sine for current x value ...
            let sine = sin(relativeX + phase)
            // ... and finally the height
            let y = parabola * strength * sine + midHeight

            // add it to the path
            path.addLineTo(x: x, y: y)
        }

        return Path(path.cgPath)
    }
}

struct WaveView: View {
    @State private var phase = 0.0
    let count: Int
    let waveOffset: CGFloat
    let strength: Double
    let frequency: Double
    let lineWidth: CGFloat
    let lineColor: Color
    let backgroundColor: Color
    let speed: Double

    /// A animated WaveView
    /// - Parameters:
    ///   - waves: The amount of wave(s), optional, default is 1
    ///   - offset: The offset between wave(s), optional, default is 10
    ///   - strength: The height of the wave(s)
    ///   - frequency: The frequency of the wave(s)
    ///   - lineWidth: The width of the wave(s)
    ///   - lineColor: The color of the wave(s)
    ///   - backgroundColor: The color of the background
    ///   - speed: The speed at which the wave(s) move, lower values are faster
    init(waves: Int = 1, offset: CGFloat = 10, strength: Double, frequency: Double,
         lineWidth: CGFloat, lineColor: Color, backgroundColor: Color, speed: Double) {
        self.count = waves
        self.waveOffset = offset
        self.strength = strength
        self.frequency = frequency
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.backgroundColor = backgroundColor
        self.speed = speed
    }

    var body: some View {
        ZStack {
            ForEach(1 ..< count + 1) { i in
                Wave(strength: strength, frequency: frequency, phase: self.phase)
                    .stroke(lineColor.opacity(Double(i) / Double(count)), lineWidth: lineWidth)
                    .offset(y: CGFloat(i) * waveOffset)
            }
        }
        .background(backgroundColor)
        .onAppear {
            withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                self.phase = .pi * 2
            }
        }
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(waves: 5,
                 offset: 10,
                 strength: 50,
                 frequency: 10,
                 lineWidth: 5,
                 lineColor: .red,
                 backgroundColor: .white,
                 speed: 0.8)
    }
}

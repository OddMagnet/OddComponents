//
//  ProgressViewStyles.swift
//  OddComponents
//
//  Created by Michael Brünen on 08.02.21.
//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var trimAmount: Double = 0.7
    var strokeColor: Color = .blue
    var strokeWidth: CGFloat = 25.0

    let formatter = NumberFormatter()
    var rotation: Angle {
        Angle(radians: .pi * (1 - trimAmount)) + Angle(radians: .pi / 2)
    }

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0.0
        formatter.numberStyle = .percent
        let percentage = formatter.string(from: fractionCompleted as NSNumber) ?? "0%"
        return ZStack {
            // Background
            Circle()
                .rotation(rotation)
                .trim(from: 0, to: CGFloat(trimAmount))
                .stroke(
                    strokeColor.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )

            // Progress
            Circle()
                .rotation(rotation)
                .trim(from: 0, to: CGFloat(trimAmount) * CGFloat(fractionCompleted))
                .stroke(
                    strokeColor,
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )

            // Label
            Text(percentage)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .offset(y: -5)
                .animation(nil) // no animation since the last step moves the text otherwise
        }
    }
}

struct ProgressViewStyles: View {
    @State private var progress = 0.1

    var body: some View {
        ProgressView("Tap to download...", value: progress, total: 1.0)
            .frame(width: 300)
            .progressViewStyle(GaugeProgressStyle())
            .onTapGesture {
                if progress < 1.0 {
                    withAnimation {
                        progress += 0.15
                    }
                }
            }
    }
}

struct ProgressViewStyles_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewStyles()
    }
}

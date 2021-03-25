//
//  PieChartView.swift
//  OddComponents
//
//  Created by Michael Brünen on 25.03.21.
//

import SwiftUI

struct PieSegment: Shape, Identifiable {
    let data: DataPoint
    var id: Int { data.id }
    var startAngle: Double
    var amount: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle, amount) }
        set {
            startAngle = newValue.first
            amount = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        var path = Path()
        path.move(to: center)
        path.addRelativeArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngle),
            delta: Angle(radians: amount)
        )
        return path
    }
}

struct PieChartView: View {
    let pieSegments: [PieSegment]
    let showLegend: Bool
    let strokeWidth: Double?

    init(dataPoints: [DataPoint], showLegend: Bool = false, strokeWidth: Double? = nil) {
        var segments = [PieSegment]()
        let total = dataPoints.reduce(0) { $0 + $1.value }
        var startAngle = -Double.pi / 2     // move the start by -90 degree, so it's at the top

        for point in dataPoints {
            let amount = Double.pi * 2 * (point.value / total)  // 360 * percentage this point takes in the chart
            let segment = PieSegment(data: point, startAngle: startAngle, amount: amount)
            segments.append(segment)
            startAngle += amount                                // update the startAngle after each new segment
        }

        pieSegments = segments
        self.showLegend = showLegend
        self.strokeWidth = strokeWidth
    }

    @ViewBuilder var mask: some View {
        if let strokeWidth = strokeWidth {
            Circle().strokeBorder(Color.white, lineWidth: CGFloat(strokeWidth))
        } else {
            Circle()
        }
    }

    var body: some View {
        VStack {
            ZStack {
                ForEach(pieSegments) { segment in
                    segment
                        .fill(segment.data.color)
                }
            }
            .mask(mask)
            VStack(alignment: .leading) {
                ForEach(pieSegments) { segment in
                    HStack {
                        Circle()
                            .fill(segment.data.color)
                            .frame(width: 20, height: 20)
                        Text(segment.data.title)
                    }
                }
            }
        }
    }
}

struct PieChartExampleView: View {
    @State private var redAmount = Double.random(in: 10...100)
    @State private var yellowAmount = Double.random(in: 10...100)
    @State private var greenAmount = Double.random(in: 10...100)
    @State private var blueAmount = Double.random(in: 10...100)

    var data: [DataPoint] {
        [
            DataPoint(id: 1, value: redAmount, color: .red, title: "Red Color"),
            DataPoint(id: 2, value: yellowAmount, color: .yellow, title: "Yellow Color"),
            DataPoint(id: 3, value: greenAmount, color: .green, title: "Green Color"),
            DataPoint(id: 4, value: blueAmount, color: .blue, title: "Blue Color")
        ]
    }

    var body: some View {
        PieChartView(dataPoints: data, showLegend: true, strokeWidth: 70)
            .onTapGesture {
                withAnimation {
                    redAmount = Double.random(in: 25...75)
                    yellowAmount = Double.random(in: 25...75)
                    greenAmount = Double.random(in: 25...75)
                    blueAmount = Double.random(in: 25...75)
                }
            }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartExampleView()
    }
}

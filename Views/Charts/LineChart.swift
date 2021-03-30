//
//  LineChart.swift
//  OddComponents
//
//  Created by Michael Brünen on 30.03.21.
//

import SwiftUI

struct LineDataPoint {
    let value: Double
}

struct LineChartShape: Shape {
    let dataPoints: [LineDataPoint]
    let pointSize: CGFloat
    let maxValue: Double
    let drawingLines: Bool

    init(dataPoints: [LineDataPoint], pointSize: CGFloat, drawingLines: Bool) {
        self.dataPoints = dataPoints
        self.pointSize = pointSize
        self.drawingLines = drawingLines

        let highestPoint = dataPoints.max { $0.value < $1.value }
        maxValue = highestPoint?.value ?? 1
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let drawRect = rect.insetBy(dx: pointSize, dy: pointSize)

        let xMultiplier = drawRect.width / CGFloat(dataPoints.count - 1)
        let yMultiplier = drawRect.height / CGFloat(maxValue)

        for (index, dataPoint) in dataPoints.enumerated() {
            var x = xMultiplier * CGFloat(index)
            var y = yMultiplier * CGFloat(dataPoint.value)

            y = drawRect.height - y     // invert, because smaller y value means higher up

            // add the min values, so the offset from pointSize does not change the points x and y
            x += drawRect.minX
            y += drawRect.minY

            if drawingLines {
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            } else {
                x -= pointSize / 2
                y -= pointSize / 2
                path.addEllipse(in: CGRect(x: x, y: y, width: pointSize, height: pointSize))
            }
        }

        return path
    }
}

struct LineChart: View {
    let dataPoints: [LineDataPoint]
    var lineColor = Color.primary
    var lineWith: CGFloat = 2
    var pointSize: CGFloat = 5
    var pointColor = Color.primary
    var grids: Int = 10

    var maxValue: Double {
        let highestPoint = dataPoints.max { $0.value < $1.value }
        return highestPoint?.value ?? 1
    }

    func gridLines() -> some View {
        VStack {
            ForEach(1...grids, id: \.self) { _ in
                Divider()
                Spacer()
            }
        }
    }

    func numberFor(grid value: Int) -> String {
        let number = maxValue / Double(grids) * Double(value)
        return String(Int(number))
    }

    func gridNumbers() -> some View {
        VStack {
            ForEach((1...grids).reversed(), id: \.self) { i in
                Text(numberFor(grid: i))
                    .padding(.horizontal)
                    .animation(nil)
                Spacer()
            }
        }
    }

    var body: some View {
        HStack {
            gridNumbers()
                .font(.caption2)

            ZStack {
                gridLines()

                if lineColor != .clear {
                    LineChartShape(dataPoints: dataPoints, pointSize: pointSize, drawingLines: true)
                        .stroke(lineColor, lineWidth: lineWith)
                }

                if pointColor != .clear {
                    LineChartShape(dataPoints: dataPoints, pointSize: pointSize, drawingLines: false)
                        .fill(pointColor)
                }
            }
        }
    }
}

struct LineChartDemoView: View {
    @State private var data = makeExampleDataPoints()

    var body: some View {
        LineChart(dataPoints: data, lineColor: .blue, lineWith: 5, pointSize: 5, pointColor: .red, grids: 10)
            .frame(width: 400, height: 300)
            .onTapGesture {
                withAnimation {
                    data = Self.makeExampleDataPoints()
                }
            }
    }

    static func makeExampleDataPoints() -> [LineDataPoint] {
        var isGoingUp = true
        var currentValue = 50.0

        return (1...50).map { _ in
            if isGoingUp {
                currentValue += Double.random(in: 1...10)
            } else {
                currentValue += -Double.random(in: 1...10)
            }

            if isGoingUp {
                if Int.random(in: 0..<10) == 0 { isGoingUp.toggle() }
            } else {
                if Int.random(in: 0..<7) == 0 { isGoingUp.toggle() }
            }

            return LineDataPoint(value: abs(currentValue))
        }
    }

}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChartDemoView()
    }
}

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

struct LineDataSet: Identifiable {
    let id: Int
    let dataPoints: [LineDataPoint]
    var lineColor = Color.primary
    var pointColor = Color.primary

    init(dataPoints: [LineDataPoint], lineColor: Color = .primary, pointColor: Color = .primary) {
        self.id = Int.random(in: 1..<Int.max)
        self.dataPoints = dataPoints
        self.lineColor = lineColor
        self.pointColor = pointColor
    }
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
    let dataSets: [LineDataSet]
    var lineWidth: CGFloat
    var pointSize: CGFloat
    var grids: Int

    var maxValue: Double {
        var absoluteMax = 0.0

        for set in dataSets {
            let highestPoint = set.dataPoints.max { $0.value < $1.value }
            if let value = highestPoint?.value {
                if absoluteMax < value { absoluteMax = value }
            }
        }

        return absoluteMax
    }

    /// Convenience initialiser for a single dataPoint set
    /// - Parameters:
    ///   - dataPoins: The set of data points
    ///   - lineColor: The color of the lines, `.clear` to hide them
    ///   - lineWidth: The width of the lines
    ///   - pointColor: The color of the points, `.clear` to hide them
    ///   - pointSize: The size of the points
    ///   - grids: The amount of grids to display
    init(dataPoins: [LineDataPoint],
         lineColor: Color = .primary,
         lineWidth: CGFloat = 2,
         pointColor: Color = .primary,
         pointSize: CGFloat = 5,
         grids: Int = 10
    ) {
        let dataSets = [LineDataSet(dataPoints: dataPoins, lineColor: lineColor, pointColor: pointColor)]
        self.init(dataSets: dataSets, lineWidth: lineWidth, pointSize: pointSize, grids: grids)
    }

    /// Convenience initialiser for multiple dataPoint sets
    /// - Parameters:
    ///   - dataSets: An array of `LineDataSet`, containing the data points, and the colors for lines and points, use `.clear` to hide them
    ///   - lineWidth: The width of the lines
    ///   - pointSize: The size of the points
    ///   - grids: The amount of grids to display
    init(dataSets: [LineDataSet], lineWidth: CGFloat = 2, pointSize: CGFloat = 5, grids: Int = 10) {
        self.dataSets = dataSets
        self.lineWidth = lineWidth
        self.pointSize = pointSize
        self.grids = grids
    }

    var body: some View {
        HStack {
            gridNumbers()
                .font(.caption2)

            ZStack {
                gridLines()

                ForEach(dataSets) { dataSet in
                    if dataSet.lineColor != .clear {
                        LineChartShape(dataPoints: dataSet.dataPoints, pointSize: pointSize, drawingLines: true)
                            .stroke(dataSet.lineColor, lineWidth: lineWidth)
                    }

                    if dataSet.pointColor != .clear {
                        LineChartShape(dataPoints: dataSet.dataPoints, pointSize: pointSize, drawingLines: false)
                            .fill(dataSet.pointColor)
                    }
                }
            }
        }
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
}

struct LineChartDemoView: View {
    @State private var data = makeExampleDataPoints()
    @State private var data2 = makeExampleDataPoints()

    var body: some View {
        LineChart(dataPoins: data, lineColor: .blue, pointColor: .red)
//        LineChart(dataSets: [
//            LineDataSet(dataPoints: data, lineColor: .blue, pointColor: .red),
//            LineDataSet(dataPoints: data2, lineColor: .yellow, pointColor: .green)
//        ])
            .frame(width: 400, height: 300)
            .onTapGesture {
                withAnimation {
                    data = Self.makeExampleDataPoints()
                    data2 = Self.makeExampleDataPoints()
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

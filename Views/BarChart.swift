//
//  BarChartView.swift
//  OddComponents
//
//  Created by Michael Brünen on 26.03.21.
//

import SwiftUI

struct BarChart: View {
    let dataPoints: [DataPoint]
    let maxValue: Double

    init(dataPoints: [DataPoint]) {
        self.dataPoints = dataPoints

        let highestPoint = dataPoints.max { $0.value < $1.value }
        maxValue = highestPoint?.value ?? 1
    }

    var body: some View {
        // ZStack so grid lines can be drawn in the background
        ZStack {
            // VStack for the background grid lines
            VStack {
                ForEach(1...10, id: \.self) { _ in
                    Divider()
                    Spacer()
                }
            }

            // HStack for the grid numbers and bars
            HStack {
                // VStack for the grid numbers
                VStack {
                    ForEach((1...10).reversed(), id: \.self) { i in
                        Text(String(Int(maxValue / 10 * Double(i))))
                            .padding(.horizontal)
                            .animation(nil)
                        Spacer()
                    }
                }
                // For every bar needed
                ForEach(dataPoints) { data in
                    // a VStack to contain the bar itself and it's title
                    VStack {
                        Rectangle()
                            .fill(data.color)
                            .scaleEffect(y: CGFloat(data.value / maxValue), anchor: .bottom)

                        Text(data.title)
                            .bold()
                    }
                }
            }
        }
    }
}

struct BarChartDemoView: View {
    @State private var redAmount = Double.random(in: 10...100)
    @State private var yellowAmount = Double.random(in: 10...100)
    @State private var greenAmount = Double.random(in: 10...100)
    @State private var blueAmount = Double.random(in: 10...100)
    @State private var randomAmount = Double.random(in: 10...100)

    var data: [DataPoint] {
        [
            DataPoint(id: 1, value: redAmount, color: .red, title: "Red Color"),
            DataPoint(id: 2, value: yellowAmount, color: .yellow, title: "Yellow Color"),
            DataPoint(id: 3, value: greenAmount, color: .green, title: "Green Color"),
            DataPoint(id: 4, value: blueAmount, color: .blue, title: "Blue Color"),
            DataPoint(id: 5, value: randomAmount, title: "Random Color")
        ]
    }

    var body: some View {
        BarChart(dataPoints: data)
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

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartDemoView()
    }
}

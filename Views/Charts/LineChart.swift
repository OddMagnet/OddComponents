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

struct LineChart: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LineChartDemoView: View {
    var body: some View {
        LineChart()
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChartDemoView()
    }
}

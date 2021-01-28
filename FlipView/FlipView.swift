//
//  FlipView.swift
//  OddComponents
//
//  Created by Michael Brünen on 28.01.21.
//

import SwiftUI

struct FlipView<Front: View, Back: View>: View {
    enum Axis { case x, y, z, xy, xz, xyz, random }

    var isFlipped: Bool
    var axis: Axis
    var perspective: CGFloat
    var front: () -> Front
    var back: () -> Back

    var flipAxis: (CGFloat, CGFloat, CGFloat) {
        switch self.axis {
            case .x:
                return (x: 1, y: 0, z: 0)
            case .y:
                return (x: 0, y: 1, z: 0)
            case .z:
                return (x: 0, y: 0, z: 1)
            case .xy:
                return (x: 1, y: 1, z: 0)
            case .xz:
                return (x: 1, y: 0, z: 1)
            case .xyz:
                return (x: 1, y: 1, z: 1)
            case .random:
                return (x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1), z: CGFloat.random(in: 0...1))
        }
    }

    init(
        isFlipped: Bool = false,
        axis: Axis = .y,
        perspective: CGFloat = 0.7,
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back
    ) {
        self.isFlipped = isFlipped
        self.axis = axis
        self.perspective = perspective
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            front()
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: flipAxis, perspective: perspective)
                .opacity(isFlipped == true ? -1 : 1)
                .accessibility(hidden: isFlipped == true)

            back()
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: flipAxis, perspective: perspective)
                .opacity(isFlipped == true ? 1 : -1)
                .accessibility(hidden: isFlipped == false)
        }
    }
}

struct ExampleView: View {
    @State private var cardFlipped = false

    var body: some View {
        FlipView(isFlipped: cardFlipped, axis: .y) {
            Text("Front Side")
                .font(.largeTitle)
                .frame(width: 200, height: 300)
                .padding()
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } back: {
            Text("Back Side")
                .font(.largeTitle)
                .frame(width: 200, height: 300)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.7))
        .onTapGesture {
            cardFlipped.toggle()
        }
    }
}

struct FlipView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}

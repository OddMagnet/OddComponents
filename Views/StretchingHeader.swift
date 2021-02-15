//
//  StretchingHeader.swift
//  OddComponents
//
//  Created by Michael Brünen on 15.02.21.
//

import SwiftUI

struct StretchingHeader<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            VStack(content: content)
                .frame(width: geo.size.width, height: height(for: geo))
                .blur(radius: blurRadius(for: geo))
                .offset(y: offset(for: geo))
        }
    }

    /// Calculates the height for the headers container
    /// - Parameter proxy: The proxy of the header
    /// - Returns: The height needed for the header to stretch properly
    func height(for proxy: GeometryProxy) -> CGFloat {
        let y = proxy.frame(in: .global).minY
        return proxy.size.height + max(0, y)
    }

    /// Offsets the headers position so it doesn't move downwards when stretching
    /// - Parameter proxy: The proxy of the header
    /// - Returns: The offset needed for the header to not move down when stretching
    func offset(for proxy: GeometryProxy) -> CGFloat {
        let y = proxy.frame(in: .global).minY
        return min(0, -y)
    }

    /// Blurs the header when it stretches
    /// - Parameter proxy: The proxy of the header
    /// - Returns: The blur for a given amount of stretching
    func blurRadius(for proxy: GeometryProxy) -> CGFloat {
        return proxy.frame(in: .global).minY / 10 - 12
    }
}

struct DemoView: View {
    var body: some View {
        List {
            Section(
                header: StretchingHeader {
                    Image("exampleImage")
                        .resizable()
                        .scaledToFill()

                    Text("Photo by Erick Zajac on Unsplash")
                        .padding()
                }
                .frame(height: 200)
            ) {
                ForEach(0 ..< 25) { i in
                    Text("Row \(i)")
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct StretchingHeader_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}

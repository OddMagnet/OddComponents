//
//  HeroView.swift
//  OddComponents
//
//  Created by Michael Brünen on 19.12.20.
//

import SwiftUI

struct HeroViewExampleContent {
    static let imageNames: [String] = [
        "heart.fill",
        "bandage.fill",
        "cross.fill",
        "bed.double.fill",
        "cross.case.fill",
        "pills.fill"
    ]
}

struct HeroView: View {
    @State var allImages: [String]
    @State private var selectedImages: [String] = []
    @Namespace private var imageEffect

    var body: some View {
        VStack {
            Text("All images")
                .font(.headline)
            allImagesView

            Spacer()

            Text("Selected images")
                .font(.headline)
            selectedImagesView
        }
    }

    private var allImagesView: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 44))]) {
            ForEach(allImages, id: \.self) { image in
                Image(systemName: image)
                    .resizable()
                    .matchedGeometryEffect(id: image, in: imageEffect)
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        withAnimation {
                            allImages.removeAll { $0 == image }
                            selectedImages.append(image)
                        }
                    }
            }
        }
    }

    private var selectedImagesView: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 88))]) {
            ForEach(selectedImages, id: \.self) { image in
                Image(systemName: image)
                    .resizable()
                    .matchedGeometryEffect(id: image, in: imageEffect)
                    .frame(width: 88, height: 88)
                    .onTapGesture {
                        selectedImages.removeAll { $0 == image }
                        allImages.append(image)
                    }
            }
        }
    }
}

struct HeroView_Previews: PreviewProvider {
    static var previews: some View {
        HeroView(allImages: HeroViewExampleContent.imageNames)
    }
}

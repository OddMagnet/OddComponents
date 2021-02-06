//
//  ToggleStyle.swift
//  OddComponents
//
//  Created by Michael Brünen on 06.02.21.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    var checkedImage: Image = Image(systemName: "checkmark.circle.fill")
    var uncheckedImage: Image = Image(systemName: "circle")

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(configuration.isOn ? .green : .red)

            Spacer()

            Button(action: { configuration.isOn.toggle() })  {
                toggleImage(on: configuration.isOn)
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(configuration.isOn ? .medium : .large)
            }
        }
    }

    func toggleImage(on: Bool) -> Image {
        if on { return checkedImage }
        else { return uncheckedImage }
    }
}

struct ToggleStyles: View {
    @State private var isToggled = false

    var body: some View {
        List {
            Toggle("Toggle me please", isOn: $isToggled)
                .toggleStyle(CheckToggleStyle(
                                checkedImage: Image(systemName: "heart.fill"),
                                uncheckedImage: Image(systemName: "heart"))
                )
                .accentColor(.red)
        }
        .navigationTitle("Options")
    }
}

struct ToggleStyles_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToggleStyles()
        }
    }
}

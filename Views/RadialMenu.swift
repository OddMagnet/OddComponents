//
//  RadialMenu.swift
//  OddComponents
//
//  Created by Michael Brünen on 16.02.21.
//

import SwiftUI

struct RadialButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title)
            .background(Color.blue.opacity(configuration.isPressed ? 0.5 : 1))
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

// To avoid using SwiftUI's buttons, since those are generic over what content they contain
// which would require using @ViewBuilder in the RadialMenu, which is problematic since then
// the buttons content can't be placed individually
struct RadialButton {
    var label: String           // text for accessibility
    var image: Image
    var action: () -> Void
}

struct RadialMenu: View {
    let title: String                           // title of the main button
    let closedImage: Image
    let openImage: Image
    let buttons: [RadialButton]
    var openDirection: Angle = .degrees(315)    // which direction the buttons 'fly' out
    var angleRange: Angle = .degrees(90)        // how much of an angle range the buttons have
    var buttonDistance: Double = 100.0          // the distance from the main button
    var animation: Animation = .default         // the animation used for the buttons flying out

    @State private var isExpanded = false       // whether or not the buttons are currently expanded
    @State private var isShowingSheet = false   // show a sheet instead of buttons if VoiceOver is enabled

    var body: some View {
        ZStack {
            // Main button
            Button {
                if UIAccessibility.isVoiceOverRunning {
                    isShowingSheet.toggle()
                } else {
                    isExpanded.toggle()
                }
            } label: {
                isExpanded ? openImage : closedImage
            }
            .accessibility(label: Text(title))

            // Radial buttons
            ForEach(0 ..< buttons.count, id: \.self) { i in
                Button {
                    buttons[i].action()
                    isExpanded.toggle()
                } label: {
                    buttons[i].image
                }
                .accessibility(hidden: isExpanded == false)
                .accessibility(label: Text(buttons[i].label))
                .offset(offset(for: i))
            }
            .opacity(isExpanded ? 1 : 0)
            .animation(animation)
        }
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(
                title: Text(title),
                buttons: buttons.map { btn in
                    ActionSheet.Button.default(Text(btn.label), action: btn.action)
                } + [.cancel()]
            )
        }
    }

    // returns the angleRange each button needs
    var buttonAngle: Double { angleRange.radians / Double(buttons.count - 1) }

    func offset(for index: Int) -> CGSize {
        guard isExpanded else { return .zero }

        // figure out at what part of the angle the current button should be placed
        let currentAngle = buttonAngle * Double(index)

        // figure out the actual angle based on where the buttons should start
        let finalAngle = openDirection - (angleRange / 2) + Angle(radians: currentAngle)

        // calculate the final X and Y positions, subtracting 90° (.pi / 2) to start at the top
        // rather than to the right like SwiftUI does by default and multiply by the distance
        // that the buttons should be away from the middle
        let finalX = cos(finalAngle.radians - .pi / 2) * buttonDistance
        let finalY = sin(finalAngle.radians - .pi / 2) * buttonDistance

        return CGSize(width: finalX, height: finalY)
    }
}

struct RadialMenuDemoView: View {
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Camera", image: Image(systemName: "camera.fill"), action: cameraTapped),
            RadialButton(label: "Video", image: Image(systemName: "video.fill"), action: videoTapped),
            RadialButton(label: "Document", image: Image(systemName: "doc.fill"), action: documentsTapped)
        ]
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
//            Color.black
//                .edgesIgnoringSafeArea(.all)

            RadialMenu(
                title: "Demo…",
                closedImage: Image(systemName: "ellipsis.circle"),
                openImage: Image(systemName: "multiply.circle.fill"),
                buttons: buttons,
                animation: .interactiveSpring(response: 0.4, dampingFraction: 0.6)
            )
            .buttonStyle(RadialButtonStyle())
            .offset(x: -20, y: -20)
        }
    }

    func cameraTapped() {
        print("Taking a picture...")
    }

    func videoTapped() {
        print("Taking a video...")
    }

    func documentsTapped() {
        print("Scanning a document...")
    }
}

struct RadialMenu_Previews: PreviewProvider {
    static var previews: some View {
        RadialMenuDemoView()
    }
}

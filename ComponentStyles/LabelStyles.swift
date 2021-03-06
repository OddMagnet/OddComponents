//
//  LabelStyles.swift
//  OddComponents
//
//  Created by Michael Brünen on 18.03.21.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
        .padding()
        .overlay(
            Capsule()
                .stroke(Color.accentColor, lineWidth: 2)
        )
    }
}

struct CircledLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .padding(10)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Circle())

            configuration.title
                .font(.headline)
        }
    }
}

// MARK: - HoveringLabelStyle
// Custom Label that responds to 'hovering', e.g. in iPadOS with a Trackpad
// A protocol is used to restrict the generic LabelStyle of the Struct to only 'hover-aware' styles
protocol HoveringLabelStyle: LabelStyle {
    init(hovering: Bool)
}
struct HoveringLabel<LabelStyle: HoveringLabelStyle, Title: View, Icon: View>: View {
    let hoverAwareLabelStyle: LabelStyle.Type
    let title: () -> Title
    let icon: () -> Icon
    @State private var isHovered = false

    init(
        style: LabelStyle.Type,
        title: @escaping () -> Title,
        icon: @escaping () -> Icon
    ) {
        self.hoverAwareLabelStyle = style
        self.title = title
        self.icon = icon
    }

    var body: some View {
        Label(title: title, icon: icon)
            .labelStyle(hoverAwareLabelStyle.init(hovering: isHovered))
            .onHover { over in
                withAnimation(.easeInOut(duration: 0.5)) {
                    isHovered = over
                }
            }
    }
}
struct VerticalRevealingLabelStyle: HoveringLabelStyle {
    let hovering: Bool

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
                .opacity(hovering ? 1 : 0)
        }
        .contentShape(Capsule())
    }
}
struct HighlightingLabelStyle: HoveringLabelStyle {
    let hovering: Bool

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
        .padding()
        .background(Capsule().fill(Color.accentColor.opacity(hovering ? 0.2 : 0)))
        .contentShape(Capsule())
    }
}
struct ScalingIconLabelStyle: HoveringLabelStyle {
    let hovering: Bool

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .scaleEffect(hovering ? 2 : 1)
            configuration.title
                .scaleEffect(hovering ? 0 : 1)
        }
    }
}

// MARK: - AnimatedLabelStyle
protocol AnimatedLabelStyle: LabelStyle {
    init(animation: Binding<Double>)
}
struct AnimatedLabel<LabelStyle: AnimatedLabelStyle, Title: View, Icon: View>: View {
    let animatedLabelStyle: LabelStyle.Type
    let title: () -> Title
    let icon: () -> Icon
    var animationState: Binding<Double>

    init(
        style: LabelStyle.Type,
        animation: Binding<Double>,
        title: @escaping () -> Title,
        icon: @escaping () -> Icon
    ) {
        self.animatedLabelStyle = style
        self.title = title
        self.icon = icon
        self.animationState = animation
    }

    var body: some View {
        Label(title: title, icon: icon)
            .labelStyle(animatedLabelStyle.init(animation: animationState))
    }
}
struct PulsatingLabelStyle: AnimatedLabelStyle {
    let animation: Binding<Double>

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
        .scaleEffect(CGFloat(animation.wrappedValue))
        .animation(.linear(duration: 1))
    }
}

struct LabelStylesDemoView: View {
    @State private var animation: Double = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Spacer()

            Section {
                Text("Basics").font(.title)
                // The default styles, title is always accessible to VoiceOver, even in IconOnly
                Label("Default", systemImage: "clock").labelStyle(DefaultLabelStyle())
                Label("Icon Only", systemImage: "clock").labelStyle(IconOnlyLabelStyle())
                Label("Title only", systemImage: "clock").labelStyle(TitleOnlyLabelStyle())
                // A customised label, using the advanced initialiser
                Label {
                    Text("Custom")
                        .foregroundColor(.red)
                } icon: {
                    Image(systemName: "clock")
                }
            }

            Spacer()

            // Custom styles
            Section {
                Text("Beginner").font(.title)
                Label("Vertical", systemImage: "clock").labelStyle(VerticalLabelStyle())
                Label("Circled", systemImage: "clock").labelStyle(CircledLabelStyle())
            }

            Spacer()

            Section {
                Text("Intermediate").font(.title)
                // Hovering styles only work on devices where a pointer can hover over the view
                HoveringLabel(style: VerticalRevealingLabelStyle.self) {
                    Text("Hovering (Vertical reveal)")
                } icon: {
                    Image(systemName: "clock")
                }
                HoveringLabel(style: HighlightingLabelStyle.self) {
                    Text("Hovering (Highlighting)")
                } icon: {
                    Image(systemName: "clock")
                }
                HoveringLabel(style: ScalingIconLabelStyle.self) {
                    Text("Hovering (Scaling)")
                } icon: {
                    Image(systemName: "clock")
                }
            }

            Spacer()

            Section {
                Text("Advanced").font(.title)
                AnimatedLabel(style: PulsatingLabelStyle.self, animation: $animation) {
                    Text("Animated")
                } icon: {
                    Image(systemName: "clock")
                }
                .onTapGesture {
                    animation = animation == 1.0 ? 0.5 : 1.0
                }
            }

            Spacer()
        }
    }
}

struct LabelStyles_Previews: PreviewProvider {
    static var previews: some View {
        LabelStylesDemoView()
    }
}

//
//  TabbedSidebar.swift
//  OddComponents
//
//  Created by Michael Brünen on 09.03.21.
//

import SwiftUI

/// Stores a view. Used for type erasure for the TabbedSidebar
struct TitledView {
    let title: String
    let icon: Image
    let view: AnyView

    // Performs type erasure for ease of use
    /// Initialises a titled view
    /// - Parameters:
    ///   - title: The title of the view
    ///   - systemImage: The name of the systemImage to used as the icon
    ///   - view: The view presented in the main area of the screen
    init<T: View>(title: String, systemImage: String, view: T) {
        self.title = title
        self.icon = Image(systemName: systemImage)
        self.view = AnyView(view)
    }
    /// Initialises a titled view
    /// - Parameters:
    ///   - title: The title of the view
    ///   - imageNamed: The name of the image from the asset catalog to be used as the icon
    ///   - view: The view presented in the main area of the screen
    init<T: View>(title: String, imageNamed: String, view: T) {
        self.title = title
        self.icon = Image(imageNamed)
        self.view = AnyView(view)
    }
    /// Initialises a titled view
    /// - Parameters:
    ///   - title: The title of the view
    ///   - icon: The image to be used as the icon
    ///   - view: The view presented in the main area of the screen
    init<T: View>(title: String, icon: Image, view: T) {
        self.title = title
        self.icon = icon
        self.view = AnyView(view)
    }
}

/// A View that supports both a tab bar and sidebar for navigation and smoothly handles the transition between them
struct TabbedSidebar: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var selection: String? = ""
    private let views: [TitledView]

    var body: some View {
        if sizeClass == .compact {
            TabView(selection: $selection) {
                ForEach(views, id: \.title) { item in
                    item.view
                        .tabItem {
                            Text(item.title)
                            item.icon
                        }
                        .tag(item.title)
                }
            }
        } else {
            NavigationView {
                List(selection: $selection) {
                    ForEach(views, id: \.title) { item in
                        NavigationLink(destination: item.view, tag: item.title, selection: $selection) {
                            Label {
                                Text(item.title)
                            } icon: {
                                item.icon
                            }
                        }
                        .tag(item.title)
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
    }

    init(content: [TitledView]) {
        views = content
        _selection = State(wrappedValue: content[0].title)
    }
}

struct TabbedSidebar_Previews: PreviewProvider {
    static var previews: some View {
        TabbedSidebar(content: [
            TitledView(title: "Hello", systemImage: "clock", view: Text("Hello")),
            TitledView(title: "World", systemImage: "clock", view: Text("World"))
        ])
    }
}

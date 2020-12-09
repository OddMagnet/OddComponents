//
//  FilteringList.swift
//  OddComponents
//
//  Created by Michael Brünen on 17.11.20.
//

import SwiftUI

// QoL extension to enable the applyFilter function getting called on change
extension Binding {
    /// Execute code on change of the binding
    /// - Parameter handler: The code to execute on change
    /// - Returns: The Binding of the Value
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

// QoL extension to enable sorting an array by keypath
extension MutableCollection where Self: RandomAccessCollection {
    /// sorts self by the given keypath and order
    /// - Parameters:
    ///   - keyPath: The KeyPath to sort by
    ///   - order: The order to sort by
    /// - Throws: Rethrows errors from the order and sort functions
    mutating func sort<Value: Comparable>(on keyPath: KeyPath<Element, Value>,
                                      by order: (Value, Value) throws -> Bool)
    rethrows {
        try sort { try order($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
}

/// A reusable component that provides a filterable List that can easily be customized
struct FilteringList<T: Identifiable, Content: View>: View {
    let info: String                            // info string shown in the search field
    let listItems: [T]                          // data shown in the list
    let filterKeyPaths: [KeyPath<T, String>]    // keyPaths that are searched when filtering
    let sortingKeyPath: KeyPath<T, String>?     // if provided data will be sorted by this
    let sortAscending: Bool                     // search order
    let content: (T) -> Content                 // content displayed in the list's rows
    @State private var filteredItems = [T]()    // filtered data
    @State private var filterString = ""        // string to filter by

    /// A customizable filterable list
    /// - Parameters:
    ///   - data: The data for the list
    ///   - infoString: Optional, the string shown in the search field
    ///   - filterKeys: The KeyPaths being searched on user input
    ///   - sortingKey: Optional, the KeyPath by which the list is sorted
    ///   - ascending: Optional, if the sort order is ascending or not
    ///   - rowContent: The content of the lists filtered rows
    init(_ data: [T],
         infoString: String = "Type to filter",
         filterKeys: KeyPath<T, String>...,
         sortingKey: KeyPath<T, String>? = nil,
         ascending: Bool = true,
         @ViewBuilder rowContent: @escaping (T) -> Content)
    {
        info = infoString
        listItems = data
        filterKeyPaths = filterKeys
        sortingKeyPath = sortingKey
        sortAscending = ascending
        content = rowContent
    }

    var body: some View {
        VStack {
            TextField(info, text: $filterString.onChange(applyFilter))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            List(filteredItems, rowContent: content)
                .onAppear(perform: applyFilter)
        }
    }

    func applyFilter() {
        let cleanedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedFilter)
                }
            }
        }

        if let sortingKeyPath = sortingKeyPath {
            if sortAscending { filteredItems.sort(on: sortingKeyPath, by: <) }
            else { filteredItems.sort(on: sortingKeyPath, by: >) }
        }
    }
}

struct FilteringList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilteringList(singerSampleData,
                          infoString: "Search...",
                          filterKeys: \.name, \.birthplace,
                          sortingKey: \.name,
                          ascending: false)
            { singer in
                VStack(alignment: .leading) {
                    Text(singer.name)
                        .font(.headline)
                    Text(singer.birthplace)
                        .foregroundColor(.secondary)
                }

            }
            .navigationBarTitle("FilteringList example")
        }
    }
}

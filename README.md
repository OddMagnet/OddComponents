# OddComponents
A collection of reusable SwiftUI components

## Structure
On the top level is the project itself, which is only used to easily preview the collection of components in Xcode.
Aside from the `OddComponents` folder, every other folder is a reusuable component.
This `README.md` only contains a short description, more details are available in the comments of the components.

## Components
### FilteringList
A customizable List that can be filtered based on the users input.
```
    /// A customizable filterable list
    /// - Parameters:
    ///   - data: The data for the list
    ///   - infoString: Optional, the string shown in the search field
    ///   - filterKeys: The KeyPaths being searched on user input
    ///   - sortingKey: Optional, the KeyPath by which the list is sorted
    ///   - ascending: Optional, if the sort order is ascending or not
    ///   - rowContent: The content of the lists filtered rows
```

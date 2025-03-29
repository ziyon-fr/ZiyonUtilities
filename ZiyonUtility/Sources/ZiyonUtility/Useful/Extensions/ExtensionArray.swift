//
//  ExtensionArray.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 11/07/23.
//

import SwiftUI

public extension Array {

    /// Returns the index of the last element in the array.
    /// If the array is empty, this will be `-1`.
    var lastIndex: Int {
        count - 1
    }

    // MARK: - Sorting Using KeyPath

    /**
     Returns a new array sorted based on a given `KeyPath`.

     - Parameters:
        - keyPath: The key path of the property to sort by.
        - ascending: A Boolean value that determines sorting order.
                     `true` sorts from smallest to largest (e.g., `0...9`, `a...z`).
                     `false` sorts from largest to smallest (e.g., `9...0`, `z...a`).
                     Default is `true`.

     - Returns: A new array sorted by the specified key path.

     **Example Usage:**
     ```swift
     struct Person {
         let name: String
         let age: Int
     }

     let people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
     let sortedByAge = people.sortedByKeyPath(\.age)  // Sorted by age (ascending)
     ```
     */
    func sortedByKeyPath<T: Comparable>(
        _ keyPath: KeyPath<Element, T>,
        ascending: Bool = true
    ) -> [Element] {
        self.sorted {
            ascending ? ($0[keyPath: keyPath] < $1[keyPath: keyPath]) :
                        ($0[keyPath: keyPath] > $1[keyPath: keyPath])
        }
    }

    /**
     Sorts the array **in-place** using a specified `KeyPath`.

     - Parameters:
        - keyPath: The key path of the property to sort by.
        - ascending: A Boolean value that determines sorting order.
                     `true` sorts from smallest to largest (e.g., `0...9`, `a...z`).
                     `false` sorts from largest to smallest (e.g., `9...0`, `z...a`).
                     Default is `true`.

     **Example Usage:**
     ```swift
     struct Person {
         let name: String
         let age: Int
     }

     var people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
     people.sortByKeyPath(\.age)  // Sorts people in-place by age (ascending)
     ```
     */
    mutating func sortByKeyPath<T: Comparable>(
        _ keyPath: KeyPath<Element, T>,
        ascending: Bool = true
    ) {
        self.sort {
            ascending ? ($0[keyPath: keyPath] < $1[keyPath: keyPath]) :
                        ($0[keyPath: keyPath] > $1[keyPath: keyPath])
        }
    }
}

public extension Array {

    /// Initializes an Array from a given Collection.
    ///
    /// - Parameter from: A collection whose elements match the Array's Element type.
    init<T: Collection>(from: T) where T.Element == Element {
        self = Array(from)
    }

    /// Safely accesses an element at the given index.
    ///
    /// - Parameter index: The index of the element to retrieve.
    /// - Returns: The element at the given index, or `nil` if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    /// - Parameter from: A collection whose elements match the Array's Element type.
        static func from<T: Collection>(_ collection: T) -> [Element] where T.Element == Element {
            Array(collection)
        }
}

public extension Collection {

    // MARK: - Categorization
    /// Splits the collection into two arrays based on a given predicate.
    /// - Parameter predicate: A closure that determines whether an element belongs to the matching group.
    /// - Returns: A tuple containing two arrays:
    ///   - `matching`: Elements that satisfy the predicate.
    ///   - `notMatching`: Elements that do not satisfy the predicate.
    ///
    /// - Example:
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let (evens, odds) = numbers.categorize { $0.isMultiple(of: 2) }
    /// print(evens) // [2, 4]
    /// print(odds)  // [1, 3, 5]
    /// ```
    func categorize(_ predicate: (Element) -> Bool) -> (matching: [Element], notMatching: [Element]) {
        var matching = [Element]()
        var notMatching = [Element]()

        for element in self {
            if predicate(element) {
                matching.append(element)
            } else {
                notMatching.append(element)
            }
        }

        return (matching, notMatching)
    }

    // MARK: - Utility Properties
    /// A computed property that returns `true` if the collection is not empty.
    var isNotEmpty: Bool {
        !isEmpty
    }

    // MARK: - Comparison
    /// Checks if the collection is different from another collection.
    /// - Parameter comparator: The collection to compare against.
    /// - Returns: `true` if the collection does not contain the same elements as the comparator.
    ///
    /// - Example:
    /// ```swift
    /// let array1 = [1, 2, 3]
    /// let array2 = [4, 5, 6]
    /// let result = array1.isDifferent(from: array2) // true
    /// ```
    func isDifferent(from comparator: Self) -> Bool where Element: Equatable {
        !contains(comparator)
    }

    /// Checks if all elements in the collection are different from a given element.
    /// - Parameter element: The element to compare against.
    /// - Returns: `true` if all elements are different from the provided element.
    ///
    /// - Example:
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let result = numbers.allElementsAreDifferent(from: 3) // false
    /// ```
    func allElementsAreDifferent(from element: Element) -> Bool where Element: Equatable {
        allSatisfy { $0 != element }
    }
}


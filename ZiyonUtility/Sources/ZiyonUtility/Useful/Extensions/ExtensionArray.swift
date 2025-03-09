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

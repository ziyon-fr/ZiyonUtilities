//
//  ExtensionEquatable.swift
//  ZiyonUtility
//
//  Created by Leon Salvatore on 29/03/2025.
//

import SwiftUI

public extension Equatable {
    /// Returns true if the value is equal to the comparative value
    func isEqualTo(_ other: Self) -> Bool {
        return self == other
    }

    /// Returns true if the value is different from the comparative value
    func isDifferentFrom(_ other: Self) -> Bool {
        return self != other
    }
}

// Additional extension for Sequence where elements are Equatable
public extension Sequence where Element: Equatable {
    /// Returns true if the sequence is equal to another sequence (order matters)
    func isEqualTo(_ other: Self) -> Bool {
        return self.elementsEqual(other)
    }

    /// Returns true if the sequence is different from another sequence
    func isDifferentFrom(_ other: Self) -> Bool {
        return !self.elementsEqual(other)
    }
}


//
//  ExtensionBinding.swift
//  Ziyon
//
//  Created by Elioene Leon Silves Fernandes on 14/10/2023.
//

import SwiftUI

// MARK: - String Binding Extensions

public extension Binding where Value == String {

    /// Limits the number of characters in a `Binding<String>` to a specified maximum.
    /// If the current value exceeds the limit, it trims the string and applies a smooth animation.
    ///
    /// - Parameter limit: The maximum number of characters allowed.
    /// - Returns: A modified `Binding<String>` with the applied character limit.
    func maxCharacters(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                withAnimation(.smooth) {
                    self.wrappedValue = String(self.wrappedValue.prefix(limit))
                }
            }
        }
        return self
    }

    /// Limits the length of a `Binding<String>` by removing the last character when exceeding the limit.
    ///
    /// - Parameter limit: The maximum number of characters allowed.
    /// - Returns: A modified `Binding<String>` that enforces the length restriction.
    func maxLength(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

// MARK: - Boolean Binding Extensions

public extension Binding where Value == Bool  {

    /// Initializes a `Binding<Bool>` from a `Binding<T?>`, where `true` represents a non-nil value.
    /// When set to `false`, the wrapped value is reset to `nil`.
    ///
    /// - Parameter value: A binding to an optional value.
    init<T>(value: Binding<T?>) {
        self.init(
            get: { value.wrappedValue != nil },
            set: { if !$0 { value.wrappedValue = nil } }
        )
    }
}

// MARK: - Optional String Binding

public extension Binding where Value == String  {

    /// Initializes a `Binding<String>` from a `Binding<String?>`, replacing `nil` with an empty string.
    ///
    /// - Parameter value: A binding to an optional string.
    init(value: Binding<String?>) {
        self.init(
            get: { value.wrappedValue ?? "" },
            set: { value.wrappedValue = $0 }
        )
    }
}

// MARK: - Generic Equatable Binding

public extension Binding where Value: Equatable {

    /// Initializes a `Binding<Value>` from a `Binding<Value?>`, replacing `nil` with a default proxy value.
    ///
    /// - Parameters:
    ///   - source: A binding to an optional value.
    ///   - nilProxy: A non-optional value to use when `source` is `nil`.
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}

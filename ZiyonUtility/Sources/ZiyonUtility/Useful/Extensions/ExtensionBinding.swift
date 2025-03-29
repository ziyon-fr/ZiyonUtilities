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

    /// Creates a `Binding<Bool>` from a `Binding<T?>`, where `true` represents a non-nil value.
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

// MARK: - Optional String Binding Extensions

public extension Binding where Value == String  {

    /// Creates a `Binding<String>` from a `Binding<String?>`, replacing `nil` with an empty string.
    ///
    /// - Parameter value: A binding to an optional string.
    init(value: Binding<String?>) {
        self.init(
            get: { value.wrappedValue ?? "" },
            set: { value.wrappedValue = $0 }
        )
    }
}

// MARK: - Generic Equatable Binding Extensions

public extension Binding where Value: Equatable {

    /// Creates a `Binding<Value>` from a `Binding<Value?>`, replacing `nil` with a default proxy value.
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

// MARK: - Generalized Non-Optional Binding Creation

public extension Binding {

    /// Creates a non-optional binding from an optional binding and a default value for the property.
    ///
    /// - Parameters:
    ///   - optionalSource: The optional binding of the parent object.
    ///   - defaultValue: The default value to use for the property if the optional source is `nil`.
    ///   - keyPath: A key path to the property of the parent object.
    ///
    /// - Returns: A non-optional binding to the property.
    init<T>(
        _ optionalSource: Binding<T?>,
        default defaultValue: Value,
        keyPath: WritableKeyPath<T, Value>
    ) {
        self.init(
            get: {
                optionalSource.wrappedValue?[keyPath: keyPath] ?? defaultValue
            },
            set: { newValue in
                if optionalSource.wrappedValue.isNil {
                    // Initialize the optional source with a default object if it's nil
                    optionalSource.wrappedValue = T.self as? T
                }
                optionalSource.wrappedValue?[keyPath: keyPath] = newValue
            }
        )
    }
}

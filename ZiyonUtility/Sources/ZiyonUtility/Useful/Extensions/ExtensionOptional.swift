//
//  ExtensionOptional.swift
//  ZiyonUtility
//
//  Created by Leon Salvatore on 29/03/2025.
//

public extension Optional {
    /// A Boolean value indicating whether the optional contains a non-nil value.
    ///
    /// This can be used for filtering collections of optionals or for cleaner conditional checks.
    var isNotNil: Bool {
        return self != nil
    }
    /// A Boolean value indicating whether the optional contains a nil value.
    ///
    /// This can be used for filtering collections of optionals or for cleaner conditional checks.
    var isNil: Bool {
        return self == nil
    }
}

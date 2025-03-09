//
//  File.swift
//  ZiyonUtility
//
//  Created by Elioene Silves Fernandes on 18/02/2025.
//

import SwiftUI

/// A custom environment key for specifying the currency type within the app.
public struct CurrencyTypeEnvironmentKey: EnvironmentKey {
    /// The default value for the currency type is set to `.dollar`.
   public static var defaultValue: CurrencyType = .dollar
}

public extension EnvironmentValues {
    /// A property to access the currency type within the environment.
    var currencyType: CurrencyType {
        get { self[CurrencyTypeEnvironmentKey.self] }
        set { self[CurrencyTypeEnvironmentKey.self] = newValue }
    }
}


// MARK: -  Root View Title custom environment value

/// A key for accessing values in the environment.
public struct RootViewTitlePreferenceKey: EnvironmentKey {
    
    /// The default value for the root view title.
    public static var defaultValue: LocalizedStringResource = .init("")
    
}

public extension EnvironmentValues {
    /// A computed property to access the root view title from the environment.
    var rootViewTitle: LocalizedStringResource {
        /// Getter: Gets the value to update the view.
        get { self[RootViewTitlePreferenceKey.self] }
        /// Setter: Updates the View with the new value.
        set { self[RootViewTitlePreferenceKey.self] = newValue }
    }
}

public extension View {
    /// A modifier to set the title for the root view.
    /// - Parameter title: The title to set.
    /// - Returns: A modified view with the new title set.
    ///
    /// Example Usage:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///
    ///     var body: some View {
    ///         ZiyonRootView {
    ///
    ///             Text("Content View")
    ///         }
    ///         // Setting the title for the root view using viewTitle modifier.
    ///         .viewTitle("Root View Title")
    ///     }
    /// }
    /// ```
    func viewTitle(_ title: LocalizedStringResource)-> some View {
        environment(\.rootViewTitle, title)
    }
}

// MARK: - Root View Background Color

public struct RootViewBackground: EnvironmentKey {
    public static var defaultValue: Color = .ziyonWhite
}

public extension EnvironmentValues {
    var rootViewBackground: Color {
        get { self[RootViewBackground.self] }
        set { self[RootViewBackground.self] = newValue }
    }
}

public extension View {
    func viewBackground(_ color: Color) -> some View {
        environment(\.rootViewBackground, color)
    }
}

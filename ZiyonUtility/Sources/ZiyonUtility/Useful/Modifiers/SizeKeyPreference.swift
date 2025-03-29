//
//  SizeKeyPreference.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 28/11/2023.
//

import SwiftUI

// MARK: - Preference Key for View Height

/// A `PreferenceKey` that stores a `CGFloat` value representing a view's height.
struct SizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    /// Updates the stored height value with the next computed value.
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View Extension

public extension View {

    /// Measures the height of a view and passes it to a completion handler.
    ///
    /// - Parameter completion: A closure that receives the computed height of the view.
    /// - Returns: A modified view that reports its height using a `PreferenceKey`.
    @ViewBuilder
    func sizeKeyPreference(completion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay(alignment: .center) {
                GeometryReader { geometry in
                    let height = geometry.size.height
                    Color.clear
                        .preference(key: SizeKey.self, value: height)
                        .onPreferenceChange(SizeKey.self) { newHeight in
                            completion(newHeight)
                        }
                }
            }
    }
}

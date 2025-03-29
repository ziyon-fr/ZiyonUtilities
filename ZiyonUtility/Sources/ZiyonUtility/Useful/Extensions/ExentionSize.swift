//
//  ExentionSize.swift
//  Ziyon
//
//  Created by Elioene Leon Silves Fernandes on 11/10/2023.
//

import SwiftUI

import SwiftUI

// MARK: - Preference Keys

/// A `PreferenceKey` that stores a `CGSize` value, used to track the size of a view.
public struct CGSizeKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero

    /// Updates the stored size value with the next computed value.
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/// A `PreferenceKey` that stores a `CGFloat` value, used to track the vertical offset of a scroll view.
public struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero

    /// Updates the stored offset value with the next computed value.
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View Extensions

public extension View {

    /// Measures the size of a view and passes it to a provided callback.
    ///
    /// - Parameter value: A closure that receives the computed `CGSize` of the view.
    /// - Returns: A modified view that reports its size using a `PreferenceKey`.
    @ViewBuilder
    func size(value: @escaping (CGSize) -> Void) -> some View {
        self
            .overlay {
                GeometryReader { geometry in
                    let size = geometry.size

                    Color.clear
                        .preference(key: CGSizeKey.self, value: size)
                        .onPreferenceChange(CGSizeKey.self) {
                            value($0)
                        }
                }
            }
    }

    /// Tracks the vertical scroll position of a view and passes it to a provided callback.
    ///
    /// - Parameter value: A closure that receives the `CGFloat` representing the view’s vertical position.
    /// - Returns: A modified view that reports its scroll position using a `PreferenceKey`.
    @ViewBuilder
    func scrollPosition(value: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { geometry in
                let coordinate = geometry.frame(in: .global).minY

                Color.clear
                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: coordinate)
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) {
                        value($0)
                    }
            }
        }
    }
}

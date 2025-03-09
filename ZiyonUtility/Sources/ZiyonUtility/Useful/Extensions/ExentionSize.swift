//
//  ExentionSize.swift
//  Ziyon
//
//  Created by Elioene Leon Silves Fernandes on 11/10/2023.
//

import SwiftUI

public struct CGSizeKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

public struct ScrollViewOffsetPreferenceKey:PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public extension View {
    @ViewBuilder
    func size(value: @escaping (CGSize) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    Color.clear
                        .preference(key: CGSizeKey.self, value: size)
                        .onPreferenceChange(CGSizeKey.self){
                            value($0)
                        }
                }
            }
    }
    @ViewBuilder
    func scrollPosition(value: @escaping (CGFloat) -> ())-> some View {
        overlay {
            GeometryReader { geometry in
                let coordinate = geometry.frame(in: .global).minY
                
                Color.clear
                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: coordinate)
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self){
                        value($0)
                    }
            }
        }
    }
}


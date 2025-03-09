//
//  MultiplatformModifier.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 08/07/23.
//

import SwiftUI

public extension View {
    
    func iOS<Content: View>(_ modifer: (Self) -> Content) -> some View {
        #if os(iOS)
            return modifer(self)
        #else
            return self
        #endif
    }

    func watchOS<Content: View>(_ modifer: (Self) -> Content) -> some View {
        #if os(watchOS)
            return modifer(self)
        #else
            return self
        #endif
    }
}

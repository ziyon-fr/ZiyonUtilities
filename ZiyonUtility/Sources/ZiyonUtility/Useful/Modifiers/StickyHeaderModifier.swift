//
//  StickyHeaderModifier.swift
//
//
//  Created by Elioene Silves Fernandes on 19/03/2024.
//

import SwiftUI

struct StickyHeaderModifier: ViewModifier {
    
    var height: CGFloat = 300
    var coordinateSpace: CoordinateSpace = .global
    
    func body(content: Content) -> some View {
        GeometryReader {
            let width = $0.size.width
            content
                .frame(width: width, height: stretchHeight($0))
                .clipped()
                .offset(y: stretchOffset($0))
        }
        .frame(height: height)
    }
    
    // MARK:
    private func yOffset(_ geo: GeometryProxy) -> CGFloat {
        geo.frame(in: coordinateSpace).minY
    }
    // MARK:
    private func stretchHeight(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > .zero ? (height + offset) : height
    }
    // MARK:
    private func stretchOffset(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > .zero ? -offset : .zero
    }
}

public extension View {
    func stretchHeader(_ height: CGFloat = 200) -> some View {
        modifier(StickyHeaderModifier(height: height))
    }
}

struct StickyHeaderPreview: View {
    var body: some View {
        ScrollView {
            Image(.ziyonAppIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .stretchHeader()
            
            Text("hgjghgj")
        }
        .verticalAlignment(.topLeading)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    StickyHeaderPreview()
}

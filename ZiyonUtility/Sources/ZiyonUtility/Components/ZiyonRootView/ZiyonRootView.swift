//
//  ZiyonRootView.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import Foundation
import SwiftUI

public struct ZiyonRootView<T: View, B: View>: View {

    @Environment(\.rootViewTitle) private var title
    @Environment(\.rootViewBackground) private var background

    private var icon: AssetIcon?
    private var content: T
    private var toolbar: B?
    
    public init(
        _ icon: AssetIcon? = nil,
        @ViewBuilder content: (() -> T),
        @ViewBuilder toolbar: (() -> B) = { EmptyView() }
    ) {
        self.icon = icon
        self.content = content()
        self.toolbar = toolbar()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            
            if !title.key.isEmpty {
                
            Text(title)
                .format(type: .title, weight: .black)
                .padding(.top, .spacer24)
                .padding(.horizontal, .spacer20)
        }
            content
            
        }
        .contentShape(.containerRelative)
        .background(rootViewStyle: background, in: .rect)
        .if(toolbar.isNotNil) {
            $0.toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    toolbar
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

    }
}

public extension View {
    func background(rootViewStyle style: (any ShapeStyle)? = nil, in shape: some Shape) -> some View {
        modifier(RootViewStyleModifier(style: style, shape: shape))
    }

    func rootViewStyle<S: ShapeStyle>(_ style: S) -> some View {
        self.environment(\.rootViewBackground, style)
    }
}


private struct RootViewStyleModifier<S: Shape>: ViewModifier {
    /// Optional override style (prefers this over environment value)
    let style: (any ShapeStyle)?

    /// The shape to use as background
    let shape: S

    /// The current  style from environment
    @Environment(\.rootViewBackground) private var background

    func body(content: Content) -> some View {
        // Use explicit style if provided, otherwise fall back to environment
        let effectiveStyle = style ?? background
        return content.background {
            // Type-erase the style to work with Shape.fill
            shape.fill(AnyShapeStyle(effectiveStyle))
        }
    }
}

#Preview {
    ZiyonStatefulPreview(true) { isPresented in
        ZiyonRootView {
            Spacer()
            
            Text("View")
                .frame(maxWidth: .infinity)
            
            Spacer()
        } toolbar: {
            Button("Toolbar") { }
        }
        .ignoresSafeArea(.all)
        .rootViewStyle(.ultraThinMaterial)
    }
}

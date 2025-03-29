//
//  SwiftUIView.swift
//  ZiyonUtility
//
//  Created by Leon Salvatore on 29/03/2025.
//

import SwiftUI


struct ZiyonProgressViewStyles: View {

    var body: some View {
        VStack {

            ProgressView()
                .progressViewStyle(.circularLoader)
                .progressViewTint(.black)
                .frame(height: 50)
        }
    }
}

#Preview {
    ZiyonProgressViewStyles()
}


public extension View {

    func progressViewTint(_ tint: Color) -> some View {
        environment(\.progressViewTint, tint)
    }
}


struct CircularLoaderStyleTint: EnvironmentKey {
    static var defaultValue: Color = .ziyonBlue
}


public struct CircularLoaderStyle: ProgressViewStyle {

    @Environment(\.progressViewTint) var tint
    /// View Properties
    var colors: [Color] {

        return [tint,
                tint,
                tint,
                tint,
                tint.opacity(0.7),
                tint.opacity(0.4),
                tint.opacity(0.1), .clear]
    }

    @State private var isLoading: Bool = .init()

    public func makeBody(configuration: Configuration) -> some View {

        Circle()
            .stroke(.linearGradient(colors: colors, startPoint: .top, endPoint: .bottom), lineWidth: 6)
            .rotationEffect(.init(degrees: isLoading ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: .init())) {
                   isLoading = true
                }
            }
    }
}

public extension ProgressViewStyle where Self == CircularLoaderStyle {
    static var circularLoader:  some ProgressViewStyle { CircularLoaderStyle() }
}

public extension EnvironmentValues {
    @Entry var progressViewTint: Color = .ziyonBlue
}

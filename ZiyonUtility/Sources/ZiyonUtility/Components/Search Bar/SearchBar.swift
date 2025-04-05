//
//  SearchBar.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

// MARK: Search Bar
public struct SearchBar<L: View>: View {

    @Binding var text: String
    
    @State private var isSearching: Bool = false

    @Environment(\.searchBarStyle) private var searchBarStyle
    @Environment(\.searchBarAction) private var searchBarAction
    @Environment(\.searchBarActionLabel) private var searchBarActionLabel

    var prompt: String
    var height: CGFloat
    let label: L?

    public init(
        text: Binding<String>,
        prom: String = "Search...",
        height: CGFloat = .spacer40,
        @ViewBuilder label: @escaping ()-> L? = { EmptyView() }) {

        self._text = text
        self.prompt = prom
        self.height = height
        self.label = label()
    }
    
    public var body: some View {
        
        HStack {
            HStack(spacing: .spacer12) {

                if let label {
                    label
                } else {
                    Image(systemName: "magnifyingglass")
                        .square(.spacer18)
                }

                TextField("Search...", text: $text, prompt: Text(prompt))
                    .foregroundColor(.ziyonText)
                    .onTapGesture {
                        withAnimation {
                            isSearching = true
                        }
                    }
                    .format(weight: .black)
                
                if !text.isEmpty { textFielDeleteButton }
                
                if let searchBarAction {

                    Divider()
                        .padding(.vertical, .spacer10)
                    
                    
                    /// All Icons = `line.3.horizontal.decrease.circle`
                    Button {
                        searchBarAction()
                    } label: {

                    Image(systemName: searchBarActionLabel)

                    }
                    .buttonStyle(.default(scale: 0.8))
                    
                }
               
            }
            .foregroundColor(.ziyonText)
            .padding(.horizontal, .spacer16)
            .horizontalAlignment(.leading)
            .frame(height: height)
            .background(searchBarStyle: searchBarStyle, in: .rect(cornerRadius: .spacer10))
            .animation(.bouncy, value: isSearching)
            if isSearching {
                
                Button {
                    
                    withAnimation(.bouncy) {
                        text.clean()
                        isSearching = .init()

                    }
                } label: {
                    Text("Cancelar")
                        .format()
                }
                .buttonStyle(.default())
                .transition(.asymmetric(
                    insertion: .push(from: .trailing).combined(with: .opacity),
                    removal: .push(from: .leading).combined(with: .opacity)))
                
            }
            
        }

    }
    
    
    //MARK: Delete texfield Button
    var textFielDeleteButton: some View {
        Button(action: {withAnimation {text.clean()}} ) {
            Image(systemName:"x.circle.fill")
                .square(.spacer15)
        }
        .buttonStyle(.default())
    }
}


// MARK: - Search Bar Style Environment

/// Namespace for search bar styling environment values and modifiers
public extension EnvironmentValues {

    /// The style to apply to search bars within the view hierarchy
    /// - Default: `.ziyonSecondary`
    @Entry var searchBarStyle: any ShapeStyle = .ziyonSecondary

    /// The action to perform when search is submitted
    /// - Default: `nil` (no action)
    @Entry var searchBarAction: (()-> Void)? = nil

    /// The SF Symbol name for the search action button
    /// - Default: `""` (empty string)
    @Entry var searchBarActionLabel: String = ""
}

public extension View {

    /// Sets the style for search bars within this view hierarchy
    /// - Parameter style: The `ShapeStyle` to apply (color, gradient, material etc.)
    /// - Returns: A view with the search bar style environment value set
    func searchBarStyle<S: ShapeStyle>(_ style: S) -> some View {
        self.environment(\.searchBarStyle, style)
    }

    /// Applies the current search bar style to a background shape
    /// - Parameters:
    ///   - style: Optional override style (uses environment style when `nil`)
    ///   - shape: The `Shape` to use as background
    /// - Returns: A view with styled background
    func background(searchBarStyle style: (any ShapeStyle)? = nil, in shape: some Shape) -> some View {
        modifier(SearchBarBackgroundModifier(style: style, shape: shape))
    }

    /// Configures the search action with system image and handler
    /// - Parameters:
    ///   - systemName: SF Symbol name for the action button
    ///   - action: Closure to execute when search is performed
    /// - Returns: A view with search action configured
    func searchBarAction(systemName: String, action: (() -> Void)? = nil) -> some View {
        environment(\.searchBarAction, action)
            .environment(\.searchBarActionLabel, systemName)
    }
}

/// Modifier that applies search bar style to a background shape
private struct SearchBarBackgroundModifier<S: Shape>: ViewModifier {
    /// Optional override style (prefers this over environment value)
    let style: (any ShapeStyle)?

    /// The shape to use as background
    let shape: S

    /// The current search bar style from environment
    @Environment(\.searchBarStyle) private var searchBarStyle

    func body(content: Content) -> some View {
        // Use explicit style if provided, otherwise fall back to environment
        let effectiveStyle = style ?? searchBarStyle
        return content.background {
            // Type-erase the style to work with Shape.fill
            shape.fill(AnyShapeStyle(effectiveStyle))
        }
    }
}

// MARK: - Convenience Extensions

extension Shape where Self == RoundedRectangle {

    /// Creates a rounded rectangle with continuous corner style
    /// - Parameter cornerRadius: Radius for all corners
    /// - Returns: Configured rounded rectangle
    public static func rect(cornerRadius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}



// MARK: - Usage Examples

#Preview {
    SearchBarPreview()
        .searchBarStyle(.ultraThinMaterial)


}

 struct SearchBarPreview: View {
     @State private var text: String = .init("")
    var body: some View {
        SearchBar(text: $text) {
            Image(systemName: "maginifyinglass")
        }
        .searchBarStyle(.red)
        .searchBarAction(systemName: "hourglass")

    }
}


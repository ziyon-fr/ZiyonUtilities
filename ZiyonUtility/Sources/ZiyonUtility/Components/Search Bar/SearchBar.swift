//
//  SearchBar.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

// MARK: Search Bar
public struct SearchBar<L: View, F:View>: View {

    @Binding var text: String
    
    @State private var isSearching: Bool = false
    @Environment(\.searchBarStyle) var searchBarStyle

    var prom: String
    var height: CGFloat
    var withFilter: Bool
    let filterLabel: F?
    let label: L?

    let action: (()-> Void)?
   
    public init(
        text: Binding<String>,
        prom: String = "Search...",
        height: CGFloat = .spacer40,
        withFilter: Bool = .init(),
        @ViewBuilder label: @escaping ()-> L? = { EmptyView() },
        @ViewBuilder filterLabel: @escaping ()-> F? = { EmptyView() },
        action: (()-> Void)? = nil) {
            
        self._text = text
        self.prom = prom
        self.height = height
        self.withFilter = withFilter
        self.filterLabel = filterLabel()
        self.label = label()
        self.action = action
    }
    
    public var body: some View {
        
        HStack {
            HStack(spacing: .spacer12) {

                if let label = label {
                    label
                } else {
                    Image(systemName: "magnifyingglass")
                        .square(.spacer18)
                }

                TextField("Search...", text: $text, prompt: Text(prom))
                    .foregroundColor(.ziyonText)
                    .onTapGesture {
                        withAnimation {
                            isSearching = true
                        }
                    }
                    .format(weight: .black)
                
                if !text.isEmpty { textFielDeleteButton }
                
                if withFilter {
                    
                    Divider()
                        .padding(.vertical, .spacer10)
                    
                    
                    /// All Icons = `line.3.horizontal.decrease.circle`
                    Button {
                        action?()
                    } label: {
                        if let filterLabel {
                            filterLabel
                        }
                    }
                    .buttonStyle(.default(scale: 0.8))
                    
                }
               
            }
            .foregroundColor(.ziyonText)
            .padding(.horizontal, .spacer16)
            .horizontalAlignment(.leading)
            .frame(height: height)
            .background(searchBarStyle, in: .rect(cornerRadius: .spacer10))
            .animation(.bouncy, value: isSearching)
            if isSearching {
                
                Button {
                    
                    withAnimation(.bouncy) {
                        text.clean()
                        isSearching = .init()
                        /// UIWindowScene.window
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
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
        Button(action: {text.clean()} ) {
            Image(systemName:"x.circle.fill")
                .square(.spacer15)
        }
    }
}

public extension View {
    func searchBarStyle(_ style: Color) -> some View {
        self.environment(\.searchBarStyle, style)
    }
}

public extension EnvironmentValues {
    @Entry var searchBarStyle: Color  = .ziyonSecondary
}

#Preview {
    SearchBarPreview()
        .searchBarStyle(.red)

}

 struct SearchBarPreview: View {
     @State private var text: String = .init()
    var body: some View {
        SearchBar(
            text: .constant("Searching..."),
            withFilter: true) {
                Image(systemName: "maginifyinglass")
            } filterLabel: {
                Image(systemName: "heart.fill")
            } action: {

            }

    }
}


public extension String {
    
    /// Provides a computed property to set the current string to an empty string.
    /// Usage: `myString.clean()`.
    ///
    mutating func clean() {
        self = .init()
    }
}

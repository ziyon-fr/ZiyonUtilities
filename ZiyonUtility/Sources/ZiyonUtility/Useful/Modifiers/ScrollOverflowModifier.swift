//
//  ScrollOverflowModifier.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 05/08/23.
//

import SwiftUI

public extension View {
    
    /// Use it with a VStack or another vertical View to create an optional ScrollView that only activates when its content overflow.
    /// If isn't overflowing, the content height will be exactly what it needs to appear, not growing without control like ScrollView does.
    func scrollOnVerticalOverflow(showsIndicators: Bool = false) -> some View {
        modifier(ScrollOverflowModifier(showsIndicators))
    }
}

// MARK: - Modifier
public struct ScrollOverflowModifier: ViewModifier {
    
    private var showsIndicators: Bool
    
    @State private var hasOverflow: Bool = true
    
    public init(_ showsIndicators: Bool) {
        self.showsIndicators = showsIndicators
    }
    
    public func body(content: Content) -> some View {
        if hasOverflow {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: showsIndicators) {
                    content.overlay {
                        GeometryReader { contentProxy in
                            Color.clear.onAppear {
                                hasOverflow = contentProxy.size.height > proxy.size.height
                            }.onChange(of: contentProxy.size.height) { _ in
                                hasOverflow = contentProxy.size.height > proxy.size.height
                            }
                        }
                    }
                }
            }
        } else {
            content.overlay {
                GeometryReader { proxy in
                    Color.clear.onChange(of: proxy.size.height) { _ in
                        hasOverflow = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview
//struct ScrollOverflowModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        ZiyonStatefulPreview(false) { showBig in
//            VStack {
//                VStack(spacing: 0) {
//                    if showBig.wrappedValue {
//                        Text("Item pequeno (Tente deslizar e não conseguirá)")
//                            .frame(height: 300)
//                            .background(Color.red)
//                    } else {
//                        Text("Item grande (Deslize para confirmar)")
//                            .frame(height: 900)
//                            .background(Color.blue)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .scrollOnVerticalOverflow(showsIndicators: true)
//                
//                Spacer()
//                
//                Button {
//                    showBig.wrappedValue.toggle()
//                } label: {
//                    Text("Clique para alternar a visualização")
//                }
//            }
//        }
//    }
//}

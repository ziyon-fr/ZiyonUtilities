//
//  SwiftUIView.swift
//  
//
//  Created by Elioene Silves Fernandes on 21/03/2024.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {
    
    @State private var isFistTime: Bool = .init()
    let perform: (() -> Void)?
    
    init(_ perform: (() -> Void)?) {
        self.perform = perform
    }
    func body(content: Content) -> some View {
    content
            .onAppear {
                if !isFistTime {
                    perform?()
                    isFistTime = .init()
                }
            }
    }
}
public extension View {
    // MARK: onfirstAppear
    /// Adds an action to appear when the view appers for the first time
    func onfirstAppear(perform: (() -> Void)?)-> some View {
        modifier(OnFirstAppearModifier(perform))
    }
}

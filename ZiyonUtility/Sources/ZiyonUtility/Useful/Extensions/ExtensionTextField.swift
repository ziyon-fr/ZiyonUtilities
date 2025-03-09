//
//  ExtensionTextField.swift
//  Ziyon
//
//  Created by Elioene Silves Fernandes on 17/12/2023.
//

import SwiftUI

public struct TextLengthLimiter: ViewModifier {
    @Binding var text: String
    let maxLength: Int
    
    public func body(content: Content) -> some View {
        content
            .onReceive(text.publisher.collect()) { output in
                text = String(output.prefix(maxLength)) 
            }
    }
}

public extension TextField {
    func limitTextLength(_ text: Binding<String>,
                         to maxLength: Int) -> some View {
        self.modifier(TextLengthLimiter(text: text,
                                        maxLength: maxLength))
    }
}

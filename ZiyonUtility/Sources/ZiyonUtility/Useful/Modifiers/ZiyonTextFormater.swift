//
//  ZiyonTextFormater.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func format(
        color: Color = .ziyonPrimary,
        type: TextType = .caption,
        weight: Font.Weight = .regular,
        alignment: TextAlignment = .leading
    ) -> some View {
        
       foregroundColor(color)
            .font(.roboto(type: type, weight: weight))
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: .init(), vertical: true)
            .textSelection(.enabled)
    }
}

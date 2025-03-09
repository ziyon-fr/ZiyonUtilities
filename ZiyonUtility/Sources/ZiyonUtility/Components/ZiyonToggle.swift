//
//  ZiyonToggle.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 27/08/23.
//

import SwiftUI

public struct ZiyonToggle: View {
    
    @Binding private var isOn: Bool
    private var isEnabled: Bool
    @State private var highlightColor: Color
    
    public init(isOn: Binding<Bool>, isEnabled: Bool = true, highlightColor: Color = .ziyonPrimary) {
        self._isOn = isOn
        self.isEnabled = isEnabled
        self.highlightColor = highlightColor
    }
    
    // MARK: Body
    public var body: some View {
        if isEnabled {
            RoundedRectangle(cornerRadius: .spacer12)
                .strokeBorder(highlightColor, lineWidth: 1)
                .background {
                    RoundedRectangle(cornerRadius: .spacer12)
                        .fill(isOn ? highlightColor : .ziyonSecondary)
                        .frame(width: .spacer50 - 1, height: .spacer24 - 1)
                }
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .strokeBorder(highlightColor, lineWidth: 1)
                        .background {
                            Circle()
                                .fill(Color.ziyonWhite)
                                .frame(width: .spacer24 - 1, height: .spacer24 - 1)
                        }
                        .frame(width: .spacer24, height: .spacer24)
                }
                .frame(width: .spacer50, height: .spacer24)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isOn.toggle()
                    }
                }
        } else {
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: .spacer12)
                    .fill(highlightColor)
                
                Circle()
                    .fill(.white)
                    .frame(width: .spacer24 - 2, height: .spacer24 - 2)
                    .padding(.horizontal, 1)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            .frame(width: .spacer50, height: .spacer24)
            .opacity(0.4)
        }
    }
}

// MARK: Preview
#Preview {
    ZiyonStatefulPreview(true) { isFirstEnabled in
        VStack(spacing: .spacer20) {
            Text("Exemplo de Toggle:")
            
            ZiyonStatefulPreview(false) { isOn in
                ZiyonToggle(isOn: isOn, isEnabled: isFirstEnabled.wrappedValue)
            }
            
            Text("Exemplo de Toggle com cor diferente:")
            
            ZiyonStatefulPreview(false) { isOn in
                ZiyonToggle(isOn: isOn, isEnabled: isFirstEnabled.wrappedValue, highlightColor: .ziyonError)
            }
            
            Text("Alterar estado da Toggle acima:")
            
            ZiyonToggle(isOn: isFirstEnabled)
        }
    }
}

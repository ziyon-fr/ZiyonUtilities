//
//  ZiyonEmptyViewButton.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

public struct ZiyonEmptyViewButton<T: View>: View {
    
    private var title: LocalizedStringKey
    private var message: LocalizedStringKey?
    private var icon: AssetIcon?
    private var destination: T
    
    private let height: CGFloat = 140
    
    public init(_ title: LocalizedStringKey,
                message: LocalizedStringKey? = nil,
                icon: AssetIcon? = nil,
                @ViewBuilder destination: @escaping (() -> T)
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.destination = destination()
    }
    
    public var body: some View {
        NavigationLink(destination: destination) {
            RoundedRectangle(cornerRadius: .spacer20)
                .stroke(
                    Color.ziyonText,
                    style: StrokeStyle(lineWidth: 1, dash: [.spacer10, .spacer10])
                )
                .frame(height: height)
                .overlay(alignment: .center) {
                    VStack(spacing: .spacer8) {
                        if let message {
                            Text(message).format(type: .small)
                        }
                        
                        HStack(spacing: .spacer8) {
                            if let icon = icon {
                                Image(icon)
                                    .square(.spacer16)
                                    .foregroundColor(.ziyonText)
                            }
                            
                            Text(title).format()
                        }
                    }
                }
        }
    }
}

// MARK: - Preview
struct ZiyonEmptyViewButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZiyonEmptyViewButton(
                "Criar",
                message: "Clique aqui para criar",
                icon: .plusFill,
                destination: {}
            )
        }
        .padding(.horizontal)
    }
}

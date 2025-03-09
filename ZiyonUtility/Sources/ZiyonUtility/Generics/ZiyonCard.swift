//
//  ZiyonCard.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 19/02/23.
//

import SwiftUI

public struct ZiyonCard<T: View>: View {
    
    private let title: LocalizedStringKey
    private let icon: AssetIcon
    private let backgroundColor: Color
    private let destination: (() -> T)
    
    public init(
        title: LocalizedStringKey,
        icon: AssetIcon,
        backgroundColor: Color,
        @ViewBuilder destination: @escaping (() -> T)
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: .spacer10) {
                Image(icon)
                    .square(.spacer36)
                    .foregroundColor(.ziyonText)
                
                Text(title)
                    .format(weight: .light)
                    .lineLimit(2, reservesSpace: true)
            }
            .padding(.spacer20)
            .frame(width: 160, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(.spacer20)
        }
    }
}

// MARK: Preview
struct ZiyonCard_Previews: PreviewProvider {
    static var previews: some View {
        ZiyonCard(title: "Título", icon: .home, backgroundColor: .ziyonSecondary) {
            // Destination
        }
    }
}

//
//  ZiyonNavigation.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 08/07/23.
//

import SwiftUI

public struct ZiyonNavigation<T: View>: View {
    
    @State private var isPresented: Bool = false
    
    let title: String
    let textType: TextType
    let textWeight: Font.Weight
    let leadingIcon: AssetIcon?
    let trailingIcon: AssetIcon
    let destination: (() -> T)
    let onDismiss: (() -> Void)?
    
    public init(
        _ title: String,
        textType: TextType = .caption,
        textWeight: Font.Weight = .regular,
        leadingIcon: AssetIcon? = nil,
        trailingIcon: AssetIcon = .chevronForward,
        @ViewBuilder destination: @escaping (() -> T),
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.textType = textType
        self.textWeight = textWeight
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    // MARK: Body
    public var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack(spacing: .spacer12) {
                if let leadingIcon {
                    Image(leadingIcon)
                        .square(.spacer24)
                        .foregroundColor(.ziyonText)
                }
                
                Text(title.localized)
                    .format(type: textType, weight: textWeight)
                
                Spacer()
                
                Image(trailingIcon)
                    .square(.spacer16)
                    .foregroundColor(.ziyonText)
            }
        }
        .navigationDestination(isPresented: $isPresented, destination: destination)
        .onChange(of: isPresented) { isPresented in
            guard !isPresented else { return }
            onDismiss?()
        }
    }
}

// MARK: Preview
struct ZiyonNavigation_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZiyonNavigation("Clique aqui", leadingIcon: .home) {
                Text("Outra View")
            } onDismiss: {
                print("onDismiss()")
            }
            .padding()
        }
    }
}

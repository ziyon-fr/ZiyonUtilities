//
//  ExtensionImage.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 20/03/23.
//

import SwiftUI

public extension Image {
    
    init(_ asset: AssetIcon, isImage: Bool = false) {
        if isImage {
            self = Image(asset.rawValue)
        } else {
            self = Image(asset.rawValue).renderingMode(.template)
        }
    }
    
    func square(_ size: CGFloat, _ foregroundColor: Color = .ziyonPrimary) -> some View {
        return self
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .foregroundStyle(foregroundColor)
            .frame(width: size, height: size, alignment: .leading)
    }
}

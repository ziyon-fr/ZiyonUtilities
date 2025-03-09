//
//  ExtensionFont.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//

import SwiftUI

public extension Font {
    
    static func roboto(type: TextType = .caption, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black, .heavy:
            return .custom("Roboto-Black", size: type.textSize)
        case .bold, .semibold:
            return .custom("Roboto-Bold", size: type.textSize)
        case .ultraLight, .light:
            return .custom("Roboto-Light", size: type.textSize)
        case .medium:
            return .custom("Roboto-Medium", size: type.textSize)
        case .regular:
            return .custom("Roboto-Regular", size: type.textSize)
        default:
            return .custom("Roboto-Regular", size: type.textSize)
        }
    }
}

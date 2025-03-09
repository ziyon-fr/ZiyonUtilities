//
//  ButtonType.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 07/07/23.
//

import SwiftUI


public enum ZiyonButtonStyleConfig {
    case `default`
    case primary
    case secondary
    case ternary
    case quaternary
    
    var backgroundColor: Color {
        switch self {
        case .default: return .ziyonText
        case .primary: return .ziyonAccent
        case .secondary: return .ziyonSecondary
        case .ternary: return .clear
        case .quaternary: return .ziyonSecondary
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .default: return .ziyonWhite
        case .primary: return .ziyonWhite
        case .secondary: return .ziyonText
        case .ternary: return .ziyonText
        case .quaternary: return .ziyonAccent
        }
    }
    
    var borderColor: Color {
        switch self {
        case .ternary: return .ziyonText
        default: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .ternary: return 1
        default: return 0
        }
    }
}

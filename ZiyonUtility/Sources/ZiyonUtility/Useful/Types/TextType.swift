//
//  TextType.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//

import SwiftUI

public enum TextType {
    
    /// size = 34pt
    case title
    /// size = 24pt
    case subTitle
    /// size = 20pt
    case header
    /// size = 18pt
    case body
    /// size = 16pt
    case caption
    /// size = 14pt
    case small
    /// size = 12pt
    case legend
    /// You define the size
    case custom(size: CGFloat)
}

public extension TextType {
    var textSize: CGFloat {
        switch self {
        case .title: return 34
        case .subTitle: return 24
        case .header: return 20
        case .body: return 18
        case .caption: return 16
        case .small: return 14
        case .legend: return 12
        case .custom(let size): return size
        }
    }
}

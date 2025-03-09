//
//  File.swift
//
//
//  Created by Elioene Silves Fernandes on 18/01/2024.
//

import SwiftUI


public enum ButtonSize {
    /// size  =  50pt
    case large
    /// size =  40pt
    case normal
    /// size = 30px
    case small
    /// custom Size
    case custom(_ size: CGFloat)
    
    /// button Height
    var heigh: CGFloat {
        switch self {
        case .large:
            return 50
        case .normal:
            return 40
        case .small:
            return 30
        case .custom(let height):
            return height
        }
    }
    
}

public struct ZiyonButtonStyle: ButtonStyle {
    @State private var scale: CGFloat = 0.98
    let size: ButtonSize
    let color: Color
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .frame(height: size.heigh)
            .background(color, in: .rect(cornerRadius: .spacer10))
            .scaleEffect(configuration.isPressed ? scale : 1)
    }
}

public struct ZiyonStrokeButtonStyle: ButtonStyle {
    @State private var scale: CGFloat = 0.98
    let size: ButtonSize
    let color: Color
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .horizontalAlignment(.center)
            .frame(height: size.heigh)
            .stroke(color: color, radius: .spacer10)
            .background(.black.opacity(0.0001))
            .scaleEffect(configuration.isPressed ? scale : 1)
    }
}

public struct ZiyonPlainButtonStyle: ButtonStyle {
     let scale: CGFloat
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .background(.black.opacity(0.0001))
    }
}

 public extension ButtonStyle where Self == ZiyonButtonStyle {
     /// `ZiyonButtonStyle` adds a scalling effect triggered by the is Pressed Bollean
     static func ziyon(size: ButtonSize = .large, color: Color = .ziyonPrimary
     )-> ZiyonButtonStyle {
        return ZiyonButtonStyle(size: size, color: color)
    }
}

public extension ButtonStyle where Self == ZiyonStrokeButtonStyle {
    /// `Ziyon StrokeButtonStyle` add a stroke around the button Label
    static func stroke(size: ButtonSize = .large, color: Color = .ziyonPrimary
    )-> ZiyonStrokeButtonStyle {
        
        return ZiyonStrokeButtonStyle(size: size, color: color)
    }
}

public extension ButtonStyle where Self == ZiyonPlainButtonStyle {
    /// `Ziyon StrokeButtonStyle` add a stroke around the button Label
    static func `default`(scale: CGFloat = 0.96)-> ZiyonPlainButtonStyle {
        
        return ZiyonPlainButtonStyle(scale: scale)
    }
}

#Preview {
    VStack(spacing: .spacer20) {
        Button("Button") {
            
        }
        .buttonStyle(.stroke(size: .large, color: .red))
        
        Button("Button") {
            
        }
        .buttonStyle(.ziyon(size: .small, color: .red))
        
        Button {
            
        } label: {
//            HStack {
                Text("Button")
//                Spacer()
//                Image(systemName: "doc.on.doc.fill")
//            }
        }
        .buttonStyle(.default())
        .format(color: .blue)
       
            
    }
    .padding()
}

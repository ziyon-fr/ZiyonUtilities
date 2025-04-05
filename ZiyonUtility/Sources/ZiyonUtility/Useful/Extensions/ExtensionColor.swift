//
//  ExtensionColor.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//


import SwiftUI

import SwiftUI

public extension Color {

    // MARK: - Hexadecimal Initialization

    /**
     Initializes a `Color` from a hexadecimal integer value.

     - Parameters:
        - hex: A 6-digit (RGB) or 8-digit (RGBA) hexadecimal color code.
        - alpha: The optional alpha component (0.0 - 1.0). Defaults to `1.0`.

     **Example Usage:**
     ```swift
     let blue = Color(hex: 0x2C8DFF) // Solid blue color
     let semiTransparentRed = Color(hex: 0xFF0000, alpha: 0.5) // 50% transparent red
     ```
     */
    init(hex: Int, alpha: Double = 1.0) {
        if hex > 0xFFFFFF { // RGBA format (8 digits)
            self.init(
                .sRGB,
                red: Double((hex >> 24) & 0xFF) / 255,
                green: Double((hex >> 16) & 0xFF) / 255,
                blue: Double((hex >> 8) & 0xFF) / 255,
                opacity: Double(hex & 0xFF) / 255
            )
        } else { // RGB format (6 digits)
            self.init(
                .sRGB,
                red: Double((hex >> 16) & 0xFF) / 255,
                green: Double((hex >> 8) & 0xFF) / 255,
                blue: Double(hex & 0xFF) / 255,
                opacity: alpha
            )
        }
    }

    // MARK: - Get Hexadecimal Value

    /// Returns the hexadecimal representation of the color as an `Int`.
    var hex: Int {
        guard let components = self.cgColor?.components, components.count >= 3 else { return 0 }

        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = components.count >= 4 ? Int(components[3] * 255) : 255

        return alpha == 255
            ? (red << 16) | (green << 8) | blue // RGB (6 digits)
            : (red << 24) | (green << 16) | (blue << 8) | alpha // RGBA (8 digits)
    }
}

// MARK: - Custom Color Palette

public extension ShapeStyle where Self == Color {

    // MARK: - Primary Colors

    /// Accent color (`#8C8C8C` - Gray)
    static var ziyonAccent: Color { .init(hex: 0x8C8C8C) }

    /// Primary blue (`#2C8DFF`)
    static var ziyonBlue: Color { .init(hex: 0x2C8DFF) }

    /// Error red (`#FF5757`)
    static var ziyonError: Color { .init(hex: 0xFF5757) }

    /// Primary black (`#000000`)
    static var ziyonPrimary: Color { .init(hex: 0x000000) }

    /// Secondary background (`#F5F5F5`)
    static var ziyonSecondary: Color { .init(hex: 0xF5F5F5) }

    /// White (`#FFFFFF`)
    static var ziyonWhite: Color { .init(hex: 0xFFFFFF) }

    /// Success green (`#23B700`)
    static var ziyonSuccess: Color { .init(hex: 0x23B700) }

    /// Warning orange (`#FFB100`)
    static var ziyonWarning: Color { .init(hex: 0xFFB100) }

    // MARK: - Additional Colors

    /// Light blue (`#D8E9FD`)
    static var ziyonLightBlue: Color { .init(hex: 0xD8E9FD) }

    /// Soft purple (`#E2E5FD`)
    static var ziyonPurple: Color { .init(hex: 0xE2E5FD) }

    /// Soft green (`#D3F0DF`)
    static var ziyonGreen: Color { .init(hex: 0xD3F0DF) }

    /// Soft orange (`#F5DFD9`)
    static var ziyonOrange: Color { .init(hex: 0xF5DFD9) }

    /// Soft yellow (`#F4E6D0`)
    static var ziyonYellow: Color { .init(hex: 0xF4E6D0) }

    /// Soft red (`#FFDCDC`)
    static var ziyonRed: Color { .init(hex: 0xFFDCDC) }

    /// Dark blue (`#114077`)
    static var ziyonDarkBlue: Color { .init(hex: 0x114077) }

    /// Gray (`#C2C9D4`)
    static var ziyonGray: Color { .init(hex: 0xC2C9D4) }

    /// Light gray (`#F4F9FF`)
    static var ziyonLightGray: Color { .init(hex: 0xF4F9FF) }

    /// Neutral (`#9FABB9`)
    static var ziyonNeutral: Color { .init(hex: 0x9FABB9) }

    /// Default card color (`#C2C2C2`)
    static var cardDefault: Color { .init(hex: 0xC2C2C2) }

    // MARK: - Gradient Colors

    /// Banner overlay start (`#214A63` with `alpha = 0.8`)
    static var ziyonBannerStart: Color { .init(hex: 0x214A63, alpha: 0.8) }

    /// Banner overlay end (`#5999A1` with `alpha = 0.8`)
    static var ziyonBannerEnd: Color { .init(hex: 0x5999A1, alpha: 0.8) }

    /// Coin background start (`#FFFFFF`)
    static var ziyonCoinStart: Color { .init(hex: 0xFFFFFF) }

    /// Coin background end (`#717C93`)
    static var ziyonCoinEnd: Color { .init(hex: 0x717C93) }

    /// Onboarding overlay start (`#FFFFFF` with `alpha = 0.0`)
    static var ziyonOnboardingStart: Color { .init(hex: 0xFFFFFF, alpha: 0.0) }

    /// Onboarding overlay end (`#0C2143` with `alpha = 0.9`)
    static var ziyonOnboardingEnd: Color { .init(hex: 0x0C2143, alpha: 0.9) }

    /// Onboarding overlay end (`#00000`)
    static var ziyonText: Color { .init(hex: 0x00000) }
}

// MARK: - Version 2 Colors

public extension ShapeStyle where Self == Color {

    /// Updated accent color (`#8C8C8C`)
    static var ziyonAccentV2: Color { .init(hex: 0x8C8C8C) }
}

public extension Color {
    
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}

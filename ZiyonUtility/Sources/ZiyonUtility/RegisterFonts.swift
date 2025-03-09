//
//  RegisterFonts.swift
//
//
//  Created by Bruno Moura on 01/02/24.
//

import CoreFoundation
import CoreGraphics
import Foundation
import SwiftUI

public struct RegisterFonts {
    
    /// Configures all the UI of the package
    public static  func configurePackageUI() {
        loadPackageFonts()
    }
    
    static func loadPackageFonts() {
        let fontNames = [
            "Roboto-Black",
            "Roboto-Bold",
            "Roboto-Light",
            "Roboto-Medium",
            "Roboto-Regular",
            "Roboto-Thin",
        ]
        
        fontNames.forEach { UIFont.registerFont(bundle: .main, fontName: $0, fontExtension: "ttf") }
    }
}


extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }

        return true
    }
}

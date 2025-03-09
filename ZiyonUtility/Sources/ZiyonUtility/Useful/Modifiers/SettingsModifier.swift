//
//  SettingsModifier.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 08/07/23.
//

import SwiftUI

public extension View {
    
    func settingsSection(bottomPadding: CGFloat = .spacer90) -> some View {
        return self
            .padding()
            .background(Color.ziyonSecondary)
            .cornerRadius(.spacer15)
            .padding(.horizontal)
            .padding(.top, .spacer15)
            .padding(.bottom, bottomPadding)
    }
}

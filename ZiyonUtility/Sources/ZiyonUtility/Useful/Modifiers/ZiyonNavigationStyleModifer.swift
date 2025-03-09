//
//  ZiyonNavigationStyleModifer.swift
//  ziyon
//
//  Created by Elioene Fernandes on 08/07/23.
//

import SwiftUI

public extension View {
    func ziyonNavigationStyle()-> some View {
        self
        .padding(.spacer20)
        .background(Color.ziyonSecondary)
        .cornerRadius(.spacer15)
        .padding(.horizontal)
    }
}

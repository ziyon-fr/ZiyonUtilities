//
//  TextModifier.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 07/07/23.
//

import SwiftUI

public extension View {

    @ViewBuilder
    func textTransition(from number: Double) -> some View {
        if #available(iOS 17.0, *),  #available(watchOS 10.0, *) {
            self.contentTransition(.numericText(value: number))
            
        } else {
            self.contentTransition(.numericText())
        }
    }
}



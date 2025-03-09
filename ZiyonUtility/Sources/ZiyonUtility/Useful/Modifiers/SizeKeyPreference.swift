//
//  SizeKeyPreference.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 28/11/2023.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        defaultValue = nextValue()
    }
    
}

public extension View {
    //MARK:
      @ViewBuilder
      func sizeKeyPreference(completion: @escaping (CGFloat)-> ())-> some View {
          self.overlay(alignment: .center) {
              GeometryReader { geometry in
                  let size = geometry.size
                  Color.clear
                      .preference(key: SizeKey.self, value: size.height)
                      .onPreferenceChange(SizeKey.self) { value in
                          completion(value)
                      }
              }
          }
      }
}

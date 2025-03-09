//
//  LeadingVStack.swift
//  ziyon
//
//  Created by Elioene Fernandes on 08/07/23.
//

import SwiftUI

public struct LeadingVStack<T: View>: View {
    let content: T
    let spacing: CGFloat?
    init(spacing: CGFloat? = 15, @ViewBuilder content: @escaping () -> T) {
        self.content = content()
        self.spacing = spacing
    }
    public var body: some View  {
        VStack(alignment: .leading,spacing: spacing){
            content
        }
    }
}

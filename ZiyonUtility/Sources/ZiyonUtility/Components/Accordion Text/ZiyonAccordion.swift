//
//  ZiyonAccordion.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 17/03/23.
//

import SwiftUI


public struct ZiyonAccordion<T: View, H: View>: View {
    // View Properties
    let content: T
    let header: H
    @State var collapsible: Bool = false
    public init(@ViewBuilder content: @escaping ()-> T, @ViewBuilder header: @escaping () -> H) {
        self.content = content()
        self.header = header()
    }
    public var body: some View {
        VStack(spacing: .spacer20) {
            // Header of the Section
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    collapsible.toggle()
                }
            } label: {
                HStack {
                    Image("ziyon-percentage")
                    header
                        .font(.system(size: 16, weight: .bold, design: .serif))
                    Spacer()
                    Image(systemName: "chevron.forward")
                    /// it allows the systemName image to change its foreground color
                        .renderingMode(.template)
                    /// rotation effect to makee the chevron rotate 90 degreen when pressing the button
                        .rotationEffect(.init(degrees: collapsible ? -90 :90))
                    
                }
                .foregroundColor(.ziyonText)
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.ziyonSecondary)
                .cornerRadius(.spacer15)
            }
            .frame(height: 50)
            // The content of the Section
            VStack {
                /// Animation to display the content only when the header is tapped
                if collapsible {
                    content
                        .animation(.easeOut(duration: 0.5), value: collapsible)
                    /// drooping animation
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

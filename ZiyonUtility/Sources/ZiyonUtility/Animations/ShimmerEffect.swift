//
//  ShimmerEffect.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 25/06/23.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func shimmer(
        color: Color,
        highlight: Color,
        blur: CGFloat = .zero,
        speed: CGFloat = 2,
        blendingMode: BlendMode = .normal
    ) -> some View {
        self.modifier(ShimmerEffectModifier(
            color: color,
            highlight: highlight,
            blur: blur,
            speed: speed,
            blendingMode: blendingMode
        ))
    }
}

struct ShimmerEffectModifier: ViewModifier {
     
    @State private var moveTo: CGFloat = -0.7
    
    var color: Color
    var highlight: Color
    var blur: CGFloat
    var speed: CGFloat
    var blendingMode: BlendMode
    
    // MARK: Body
    func body(content: Content) -> some View {
        
        content
            .hidden()
            .overlay {
            Rectangle()
                .fill(color)
                .mask { content }
                .overlay { // Creating Shimmer
                    GeometryReader { proxy in
                        let size = proxy.size
                        let extraOffset = (size.height / 2.5) + blur
                        
                        Rectangle()
                            .fill(highlight)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(
                                            colors: [
                                                .ziyonWhite.opacity(0),
                                                highlight,
                                                .ziyonWhite.opacity(0)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .blur(radius: blur) // Adding the blur effect
                                    .rotationEffect(.init(degrees: -70)) // Adding Rotation
                                    // Moving to Start
                                    .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                    .offset(x: size.width * moveTo)
                            }
                            .blendMode(blendingMode)
                    }
                    .mask { content } // Masking with the Content
                }
                .onAppear { // creating the Animation when the View appears
                    DispatchQueue.main.async { // Making it happen in the main thread
                        moveTo = 0.7 // moving from beggining to end
                    }
                }
                .animation(
                    .linear(duration: speed).repeatForever(autoreverses: false),
                    value: moveTo
                )
        }
    }
}

// MARK: Preview
struct ShimmerEffectModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Text("Shimmer Effect")
                .shimmer(color: .blue, highlight: .cyan)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                .shimmer(color: .gray, highlight: .white.opacity(0.5))
           
        }
        .padding()
    }
        
}

//
//  ShakeEffect.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 15/08/23.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func shake(
        animatableData: CGFloat,
        direction: Axis = .horizontal,
        distance: CGFloat = 10,
        shakesPerUnit: Int = 3
    ) -> some View {
        self.modifier(ShakeEffectModifier(
            animatableData: animatableData,
            direction: direction,
            distance: distance,
            shakesPerUnit: shakesPerUnit
        ))
    }
}

struct ShakeEffectModifier: GeometryEffect {
    
    var animatableData: CGFloat
    var direction: Axis
    var distance: CGFloat = 5
    var shakesPerUnit: Int = 200

    func effectValue(size: CGSize) -> ProjectionTransform {
        switch direction {
        case .horizontal:
            return ProjectionTransform(CGAffineTransform(
                translationX: distance * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            ))
        case .vertical:
            return ProjectionTransform(CGAffineTransform(
                translationX: 0,
                y: distance * sin(animatableData * .pi * CGFloat(shakesPerUnit))
            ))
        }
    }
}

// MARK: Preview
struct ShakeEffectModifier_Preview: PreviewProvider {
    static var previews: some View {
        ZiyonStatefulPreview(CGFloat.zero) { attempts in
            VStack(spacing: 40) {
                Text("Horizontal Example")
                    .shake(animatableData: attempts.wrappedValue)
                
                Text("Vertical Example")
                    .shake(animatableData: attempts.wrappedValue, direction: .vertical)
                
                Text("Large Distance Example")
                    .shake(animatableData: attempts.wrappedValue, distance: 80)
                
                Text("Large amount of shake Example")
                    .shake(animatableData: attempts.wrappedValue, shakesPerUnit: 40)
                
                Button {
                    withAnimation(.default) {
                        attempts.wrappedValue += 1
                    }
                } label: {
                    Text("Shake")
                }
            }
        }
    }
}

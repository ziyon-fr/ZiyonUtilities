//
//  SwiftUIView.swift
//  
//
//  Created by Elioene Silves Fernandes on 21/04/2024.
//

import SwiftUI

struct FlipAnimation: View {
    
    @State private var showView: Bool = .init()
    
    var body: some View {
        VStack {
            ZStack {
                if showView {
                    RoundedRectangle(cornerRadius: 10)
                        .fill()
                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .transition(.flip)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.red)
                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .transition(.reverseFlip)
                }
            }
            .padding()
            
            Button("Flip") {
                withAnimation(.linear) {
                    showView.toggle()
                }
            }
        }
      
    }
}

#Preview {
    FlipAnimation()
}

public struct FlipTransitionAnimation: ViewModifier, Animatable {
    var progress: CGFloat = .zero
    
   public  var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    public func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0) )
            .rotation3DEffect(
                .init(degrees: progress * 180),
                 axis: (x: 1.0, y: 0.0, z: 0.0)
            )
    }
}

public extension AnyTransition {
     static let flip: AnyTransition = .modifier(
        active: FlipTransitionAnimation(progress: 1),
        identity: FlipTransitionAnimation())
    
    static let reverseFlip: AnyTransition = .modifier(
        active: FlipTransitionAnimation(progress: -1),
        identity: FlipTransitionAnimation())
}

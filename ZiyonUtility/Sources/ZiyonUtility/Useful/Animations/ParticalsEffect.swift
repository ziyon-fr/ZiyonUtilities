//
//  ParticalsEffect.swift
//
//
//  Created by Elioene Silves Fernandes on 13/01/2024.
//

import SwiftUI

public struct ParticalsEffect: View {
    @State private var image: String = "heart.fill"
    @State private var animate: Bool = .init()
    @State private var count: Int = .zero
    
   public var body: some View {
        
        VStack {
            
            AnimatedButton(icon: image, status: animate, active: .red, inActive: .gray) {
                animate.toggle()
                if animate {
                    count += 1
                } else {
                    count -= 1
                }
                
                
            }
        }
    }
}

extension ParticalsEffect {
    @ViewBuilder
    fileprivate func AnimatedButton(icon: String, status: Bool, active: Color, inActive: Color, action: @escaping () -> Void )-> some View {
        Button(action: action) {
            HStack(spacing: .spacer10) {
                
                Image(systemName: icon)
                    .format(color: status ? active : inActive)
                
                if count != 0 {
                    if #available(iOS 17.0, *) {
                        Text(count, format: .number)
                            .contentTransition(.numericText(value: .init(count)))
                    }
                }
            }
            .padding(.horizontal,.spacer10)
            .padding(.vertical,.spacer8)
            .background(status ? active.opacity(0.25) : Color.gray.opacity(0.5), in: Capsule())
            .particleEffect(icon: icon, status: status, active: active, inActive: inActive)
            
            
        }
    }
}

#Preview {
    ParticalsEffect()
}

/// Particles View Modifier
public extension View {
    
    @ViewBuilder
    func particleEffect(icon: String, status: Bool, active: Color, inActive: Color) -> some View {
        
         self.modifier(
            ParticlesModifer(icon: icon, status: status, active: active, inActive: inActive)
        )
    }
}

fileprivate struct Particles: Identifiable {
    var id: UUID = .init()
    var xPosition: CGFloat = .init()
    var yPosition: CGFloat = .init()
    var scale: CGFloat = .init(1)
    var opacity: CGFloat = .init(1)
    
    
    mutating func reset() {
        xPosition = .init()
        yPosition = .init(1)
        scale = .init(1)
    }
}

fileprivate struct ParticlesModifer: ViewModifier {
    
    var icon: String
    var status: Bool
    var active: Color
    var inActive: Color
    
    @State private var particles = [Particles]()
    
    func body(content: Content) -> some View {
        
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles){ particle in
                        Image(systemName: icon)
                            .format(color: status ? active : inActive)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.xPosition, y: particle.yPosition)
                            .opacity(status ? particle.opacity : 0)
                            .animation(.none, value: status)
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 0...15 {
                            let newParticle = Particles()
                            particles.append( newParticle)
                        }
                    }
                }
                .onChange(of: status) { status in
                    if !status {
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        for index in particles.indices {
                            let total: CGFloat = .init(particles.count)
                            let progress: CGFloat = .init(index) / total
                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 60
                            
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY ) + 35
                            
                            let randomScale: CGFloat = .random(in: 0.35...1)
                            
                            withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7)) {
                                
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : . random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0.0...30)
                                
                                particles[index].xPosition = randomX +  extraRandomX
                                particles[index].yPosition = -randomY + extraRandomY
                                
                            }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(.interactiveSpring(
                                response: 0.6,
                                dampingFraction: 0.7,
                                blendDuration: 0.7)
                                .delay(0.25 + Double(index) * 0.005)) {
                                    particles[index].scale = 0.001
                                }
                        }
                    }
                }
            }
    }
}

//
//  Ruler.swift
//
//
//  Created by Elioene Silves Fernandes on 23/04/2024.
//

import SwiftUI

struct Ruler: View {
    var body: some View {
        
        VStack {
            
            Spacer()
                .ruler()
            
            Spacer()
                .ruler()
            
            Rectangle()
                .fill(.pink)
                .frame(width: 76)
                .frame(height: 45)
                .ruler()
            
            Text("something")
                .frame(height: 100)
                .horizontalAlignment(.center)
                .background(.yellow)
                .ruler()
               
            
            Spacer()
                .ruler()
        }
        .verticalAlignment(.top)
        .gridFrame(size: 20)
        .ruler()
        
        
    }
}

#Preview {
    Ruler()
}

public extension View {
    func ruler(color: Color = .red)-> some View {
        modifier(RulerModifier(color: color))
    }
    
    func gridFrame(size: CGFloat = 10)-> some View {
        
        background {
          GridView(size: size)
        }
    }
}

fileprivate struct RulerModifier: ViewModifier {
    
    @State private var height: CGFloat = .zero
    @State private var width: CGFloat = .zero
    
    var color: Color
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                Color.clear
                    .overlay(alignment: .top) {
                    GeometryReader { geometry in
                        let size = geometry.size
                        
                        widthIndicator(width: size.width)
                            
                        heightIndicator(size: size)
                    
                    }
                }
            }
        
    }
    
    private func widthIndicator(width: CGFloat)-> some View {
        VStack(spacing: .zero) {
            
            Text(width.formatted() + "px")
                .format(type: .legend, weight: .black)
            
            HStack(spacing: -5) {
                Image(systemName: "chevron.left")
                    .square(10)
                    .viewVisibility(visibility: width == .zero ? .hidden : .automatic)
                
                Rectangle()
                    .fill(color)
                    .frame(height: 0.5)
                
                
                Image(systemName: "chevron.right")
                    .square(10)
                    .viewVisibility(visibility: width == .zero ? .hidden : .automatic)
            }
            
        }
        
    }
    
    private func heightIndicator(size: CGSize)-> some View {
        HStack(spacing: .zero) {
            
            VStack(spacing: -5) {
                
                Image(systemName: "chevron.up")
                    .square(10)
                    .viewVisibility(visibility: size.height == .zero ? .hidden : .automatic)
                
                Rectangle()
                    .fill(color)
                    .frame(width: 0.5)
                
                Image(systemName: "chevron.down")
                    .square(10)
                    .viewVisibility(visibility: size.height == 0 ? .hidden : .automatic)
            }
            
            Text(size.height.formatted() + "px")
                .rotationEffect(.degrees(90))
                .format(type: .legend, weight: .black)
            
        }
    }
}

struct GridView: View {
    
    var size: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                // Vertical grid lines
                ForEach(0..<Int(geometry.size.width / size), id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 0.5, height: geometry.size.height)
                        .position(x: CGFloat(index * Int(size) + 5), y: geometry.size.height / 2)
                        
                }
                
                // Horizontal grid lines
                ForEach(0..<Int(geometry.size.height / size), id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width, height: 0.5)
                        .position(x: geometry.size.width / 2, y: CGFloat(index * Int(size) + 5))
                }
            }
            
           
        }
    }
}

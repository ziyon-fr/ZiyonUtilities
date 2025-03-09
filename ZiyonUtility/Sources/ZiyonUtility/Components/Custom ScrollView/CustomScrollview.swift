//
//  CustomScrollview.swift
//
//
//  Created by Elioene Silves Fernandes on 23/04/2024.
//

import SwiftUI

struct CustomScrollviewPreview: View {
    
    
    var body: some View {
        
        ZiyonScrollView {
            ForEach(0..<5, id: \.self) { index in
                Rectangle()
                    .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                    .overlay {
                        
                    }
            }
            
        } reader: { origin in
            
        }

    }
}

#Preview {
    CustomScrollviewPreview()
}

public struct ZiyonScrollView<Content:View>: View {
    
    let axes: Axis.Set
    let showsIndicators: Bool
    let content: Content
    let reader: (_ origin: CGPoint) -> ()
    @State private var coordinateSpaceID: String = UUID().uuidString
    
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        @ViewBuilder content: () -> Content,
        reader: @escaping (_ origin: CGPoint) -> ()) {
            self.axes = axes
            self.showsIndicators = showsIndicators
            self.content = content()
            self.reader = reader
        }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            LocationReader(coordinateSpace: .named(coordinateSpaceID), onChange: reader)
            content
        }
        .coordinateSpace(name: coordinateSpaceID)
    }
}

/// Adds a transparent View and read it's center point.
///
/// Adds a GeometryReader with 0px by 0px frame.
public struct LocationReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ location: CGPoint) -> Void

    public init(coordinateSpace: CoordinateSpace, onChange: @escaping (_ location: CGPoint) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
    }
    
    public var body: some View {
        FrameReader(coordinateSpace: coordinateSpace) { frame in
            onChange(CGPoint(x: frame.midX, y: frame.midY))
        }
        .frame(width: 0, height: 0, alignment: .center)
    }
}


// Adds a transparent View and read it's frame.
///
/// Adds a GeometryReader with infinity frame.
public struct FrameReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ frame: CGRect) -> Void
    
    public init(coordinateSpace: CoordinateSpace, onChange: @escaping (_ frame: CGRect) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
    }

    public var body: some View {
        GeometryReader { geo in
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: {
                    onChange(geo.frame(in: coordinateSpace))
                })
                .onChange(of: geo.frame(in: coordinateSpace), perform: onChange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

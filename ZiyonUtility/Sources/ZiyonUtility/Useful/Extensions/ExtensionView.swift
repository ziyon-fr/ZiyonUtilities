//
//  ExtensionView.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

public extension View {
    
    func horizontalAlignment(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func verticalAlignment(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Function to customize all corner radius as you choose
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func swipeToDismiss(minimumDistance: CGFloat = .spacer50, dismiss: DismissAction) -> some View {
        let dragGesture = DragGesture(minimumDistance: minimumDistance).onChanged { value in
            if value.translation.width > .spacer100 && value.startLocation.x < .spacer20 {
                withAnimation(.spring(blendDuration: 1)) {
                    dismiss()
                }
            }
        }
        return self.gesture(dragGesture)
    }
    
    /// Adjusts the background to be rounded and colored with the color passed as a parameter
    func ziyonBackgroundStyle(color: Color = .ziyonSecondary) -> some View {
        background(
            color,
            in: .rect(cornerRadius: .defaultCornerRadius))
    }
    
    /// Function to conditionally apply modifiers based on a Boolean condition
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    /// Method to get screen frame
    func screenFrame() -> CGRect {
#if os(iOS)
        return UIScreen.main.bounds
#elseif os(macOS)
        return NSScreen.main.visibleFrame
#else
        return .init()
#endif
    }
    
    /// Method to change Button, Toggle, or any other View active state
    func enabled(_ enabled: Bool) -> some View {
        return self
            .disabled(!enabled)
            .opacity(enabled ? 1 : 0.4)
            .animation(.default, value: enabled)
    }
    /// Performs an action when the `Keyboard appears`
        func onKeyboardAppear(perform:  @escaping ()-> Void )-> some View {
            onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { result in
                print(result.name)
                DispatchQueue.main.async {
                    perform()
                }
            }
        }
    /// Performs an action when the `Keyboard Disappear`
        func onKeyboardDisappear(perform: @escaping ()-> Void )-> some View {
            onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { result in
                print(result.name)
                DispatchQueue.main.async {
                    perform()
                }
            }
        }
    /// Hides the view mantaining its frame
        @ViewBuilder
        func viewVisibility(visibility: Visibility)-> some View {
            switch visibility {
            case .automatic: self
            case .visible: self
            case .hidden: hidden()
                
            }
        }
    
    /// Creates a capsule around the View container
    func capsule(color: Color = .black, opacity: CGFloat = 1, inset: CGFloat = 2)-> some View {
        padding(.vertical, .spacer6)
            .padding(.horizontal, .spacer10)
            .background(color, in: .capsule.inset(by: inset))
            .opacity(opacity)
    }
    /// Creates a rounded background on the view
    func defaultRadialBackground(color: Color = .ziyonSecondary, radius: CGFloat = .defaultCornerRadius, padding: CGFloat = .spacer16)-> some View {
        self
            .padding(padding)
            .background(color, in: .rect(cornerRadius: radius))
    }
    /// Overlays the view with a dark material color
    func darkenOverlay(_ isOverlaing: Bool)-> some View {
        overlay {
            if isOverlaing {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
            }
        }
    }
    /// Adjust the background to be rounded and light gray
    func ziyonTextFieldStyle()-> some View {
        background(
            Color.ziyonSecondary,
            in: .rect(cornerRadius: .defaultCornerRadius))
    }
    
    func smallToolbarButton(background: Color = .ziyonSecondary) -> some View {
        self
            .padding(.vertical, .spacer8)
            .padding(.horizontal, .spacer16)
            .background(background)
            .cornerRadius(.spacer10)
    }
}

// MARK: Rounded Corner
public struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


public extension View {
    @ViewBuilder
    func stroke(
        color: Color = .ziyonPrimary,
        type: StrokeType = .roundedRectangle,
        lineWidth: CGFloat = 1,
        radius: CGFloat = .defaultCornerRadius) -> some View {
        
        switch type {
            
        case .circle: 
            background(color, in: .circle
                .stroke(style: .init(lineWidth: lineWidth)))
        case .roundedRectangle:
            background(color, in: .rect(cornerRadius: radius)
                .stroke(style: .init(lineWidth: lineWidth)))
        case .rectangle:
            background(color, in: .rect
                .stroke(style: .init(lineWidth: lineWidth)))
        case .ellipse:
            background(color, in: .ellipse
                .stroke(style: .init(lineWidth: lineWidth)))
        }
        
    }
}

public enum StrokeType {
    /// Creates a circle shape stroke
    case circle
    /// Creates a rounded rectangle shape stroke
    case roundedRectangle
    /// Creates a  rectangle shape stroke
    case rectangle
    /// Creates a ellipse shape stroke
    case ellipse
}

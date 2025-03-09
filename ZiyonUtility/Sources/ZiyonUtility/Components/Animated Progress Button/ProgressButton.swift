//
//  ProgressButton.swift.swift
//
//
//  Created by Leon Salvatore on 10/02/2024.
//

import SwiftUI

@available(iOS 17.0, *)
public struct ProgressButton<T:View>: View {
    
    var style: ProgressButtonStyle
    var color: Color
    var label: T
    /// Action Property
    var action: () async -> ProgressStatus
    /// View Properties
    @State private var isLoading: Bool = false
    @State public var status: ProgressStatus = .idle
    @State private var failed: Bool = false
    @State private var shake: Bool = false
    /// Popup Properties
    @State private var presentPopUp: Bool = false
    @State private var popupMessage: String = ""
    
    public init(
        style: ProgressButtonStyle = .default,
        color: Color = .black,
        action: @escaping () async  -> ProgressStatus,
        label: @escaping () -> T) {
        self.style = style
        self.color = color
        self.label = label()
        self.action = action
   
    }
    public var body: some View {
        Button(action: ButtonAction) {
              
            if isLoading && status == .idle {
                ProgressView()
                
            }  else  if status != .idle {
                
                Image(systemName: failed ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .square(20, failed ? Color.black : .green)
                    .contentTransition(.symbolEffect(.replace))
                    .wiggle(shake)
            }
            else {
                label
            }
                
        }
        .disabled(isLoading)
        .popover(isPresented: $presentPopUp) {
            Text(popupMessage)
                .format()
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
                .onTapGesture {
                    presentPopUp .toggle()
                }
        }
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: status)
    }
}

// MARK:: Methods
@available(iOS 17.0, *)
extension ProgressButton {
   // MARK: -
    func ButtonAction() {
        
        Task {
            
            isLoading = true
            
            let taskStatus = await(action())
            
            switch taskStatus {
                
            case .idle, .success :
                
                failed = false
                
            case .failed(let string):
                
                failed = true
                
                 UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                
                popupMessage = string
           
            }
            self.status = taskStatus
            
            if failed {
                
                try? await Task.sleep(for: .seconds(0))
                shake.toggle()
            }
           
            try? await Task.sleep(for: .seconds(0.8))

            if failed {
                presentPopUp = true
            }
            self.status = .idle
            
            isLoading = false
        }
    }
}

/// Task Status
 public enum ProgressStatus: Equatable {
    case idle
    case failed(String)
    case success
}

/// Custom Opacity Less Button Style
extension ButtonStyle where Self == OpacityLessButtonStyle {
    static var opacityLess: Self {
        Self()
    }
}

 struct OpacityLessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
/// Wiggle Extension
@available(iOS 17.0, *)
public extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        VStack(spacing: .spacer40) {
            ProgressButton(style: .large) {
               
                try? await Task.sleep(for: .seconds(2))
                   return .failed("Errou 😁")
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .horizontalAlignment(.center)
                    .defaultRadialBackground(color:.black)
                    .foregroundStyle(.white)
            }
            .buttonStyle(.default())
            
            ProgressButton(style: .default) {
               
                try? await Task.sleep(for: .seconds(2))
                return .success
                   return .failed("Errou 😁")
                
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.black)
            }
            .buttonStyle(.default())

        }
        .padding()
        .tint(.black)
        .horizontalAlignment(.trailing)
        
    } else {
        Text("Something")
    }
}
public enum ProgressButtonStyle {
    case large
    case `default`
}

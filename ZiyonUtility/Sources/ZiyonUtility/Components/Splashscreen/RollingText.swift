//
//  RollingText.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//

import SwiftUI

public struct RollingsTextEffect: View {
    
    @Binding var text: String
    var animationDuration: Double
    
    @State private(set) var characters: [String] = []
    // Alphabeth array including both uppercase and lowercase letters.
    @State private(set) var alphabeth: [String] = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "Ø"
    ]
    
    public init(
        text: Binding<String>,
        animationDuration: Double) {
            
            self._text = text
            self.animationDuration = animationDuration
            
        }
    
    public var body: some View {
        // Display a horizontal stack of letters vertically scrolling through the alphabet.
        HStack(spacing: .zero) {
            // Iterate over the characters in the 'characters' array.
            ForEach(0..<characters.count, id: \.self) { index in
                // Display a hidden 'L' character that acts as a placeholder.
                Text("L")
                    .font(.custom("Didot", size: .spacer60).bold())
                    .foregroundColor(.clear)
                    .overlay {
                        // Create a GeometryReader to access the size of the view.
                        GeometryReader { proxy in
                            let screen = proxy.size
                            let screenHeight = screen.height
                            // Find the index of the current character in the 'alphabeth' array.
                            let characterIndex = alphabeth.firstIndex(of: characters[index]) ?? 0
                            // Calculate the vertical offset based on the character index.
                            let yOffset = -CGFloat(characterIndex) * screenHeight
                            
                            // Create a vertical stack of letters from the 'alphabeth' array.
                            VStack(spacing: .zero) {
                                ForEach(alphabeth, id: \.self) { character in
                                    Text(character.lowercased())
                                        .font(.custom("Didot", size: .spacer60).bold())
                                }
                            }
                            // Apply the calculated offset to vertically scroll the letters.
                            .offset(y: yOffset)
                        }
                        .clipped() // Ensure content is clipped to the view boundaries
                    }
            }
        }
        .frame(maxWidth: 200)
        .onAppear {
            // Initialize the 'characters' array with empty strings and start animation.
            characters = Array(repeating: .init(), count: text.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateValue()
            }
        }
    }
    
    /// Updates the characters array with the text values, applying animation.
    ///
    /// This method iterates through the characters in the provided `text` and updates the `characters` array
    /// with the corresponding character values. Animation is applied to each character update, giving a dynamic
    /// appearance to the moving characters in the splash screen.
    ///
    /// - Note: The animation's response and damping fraction are adjusted based on the index of the character,
    ///   creating a gradual animation effect.
    ///
    /// - Parameters:
    ///   - text: The text to be displayed in the splash screen.
    private func updateValue() {
        for (index, value) in zip(0..<text.count, text) {
            // Calculate a fraction based on the index
            var fraction = Double(index) * 0.15
            
            // Limit the fraction value to a maximum of 0.5
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            // Apply animation with adjusted response, damping fraction, and blend duration
            withAnimation(.interactiveSpring(
                response: animationDuration,
                dampingFraction: 1 + fraction,
                blendDuration: 1 + fraction
            )) {
                // Update the character value in the array
                characters[index] = String(value)
            }
        }
    }
}


//
//  HapticManager.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 18/06/23.
//

import SwiftUI

#if canImport(CoreHaptics)
import CoreHaptics

public class HapticManager {
    
    public static let shared = HapticManager()
    
    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public func inpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    // MARK: Haptic Feedback
    public func triggerHapticFeedback(intensity: Float = 0.2, sharpness: Float = 0.2) {
        guard let hapticEngine = try? CHHapticEngine() else { return }
        
        do {
            try hapticEngine.start()
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hapticEngine.stop()
            }
        } catch {
            print("Failed to play haptic feedback: \(error)")
        }
    }
}
#endif

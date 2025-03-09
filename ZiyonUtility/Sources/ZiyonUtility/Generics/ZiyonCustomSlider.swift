////
////  ZiyonCustomSlider.swift
////  Ziyon
////
////  Created by Elioene Leon Silves Fernandes on 14/10/2023.
////
//
//import SwiftUI
//import UIKit
//#if canImport(UIKit)
//#endif
///// A SwiftUI slider that allows customization of appearance.
/////
///// This slider can be used with different types (e.g., `Float`, `Double`) and allows customization
///// of the thumb color, minimum track color, and maximum track color.
/////
///// Example usage:
///// ```swift
///// ZiyonCustomSlider(
///// value: $sliderValue, bounds: 0...1, thumbColor: .blue, minTrackColor: .green, maxTrackColor: .gray)
///// ```
/////
///// - Parameters:
/////   - value: A binding to the value of the slider. The value can be of type `Float`, `Double`, etc.
/////   - bounds: The range of the slider's values.
/////   - thumbColor: The color of the slider's thumb.
/////   - minTrackColor: The color of the minimum track of the slider. If `nil`, it defaults to `.ziyonNeutral`.
/////   - maxTrackColor: The color of the maximum track of the slider. If `nil`, it defaults to `.ziyonLight`.
/////   - onEditingChanged: A callback for when editing begins and ends.
/////
///// The `value` of the created instance is equal to the position of
///// the given value within `bounds`, mapped into `0...1`.
/////
///// The slider calls `onEditingChanged` when editing begins and ends. For
///// example, on iOS, editing begins when the user starts to drag the thumb
///// along the slider's track.
/////
///// - Important:
/////   This slider assumes that the `value` type is compatible with `UISlider`'s `value` property.
/////   If used with a type that is not compatible, a runtime error may occur.
/////
/////
///// - Note:
/////   The coordinator is responsible for handling the value change of the slider.
/////   The `valueChanged(_:)` action updates the binding.
//public struct ZiyonCustomSlider<T>: UIViewRepresentable where
//T: BinaryFloatingPoint,
//T.Stride: BinaryFloatingPoint,
//T: Comparable {
//    
//    /// A coordinator class that handles events and updates for the slider.
//    public final class Coordinator: NSObject {
//        /// A binding to the value of the slider.
//        var value: Binding<T>
//        /// A callback for when editing begins and ends.
//        var onEditingChanged: ((Bool) -> Void)?
//        
//        /// Initializes the coordinator with a binding.
//        init(value: Binding<T>, onEditingChanged: ((Bool) -> Void)?) {
//            self.value = value
//            self.onEditingChanged = onEditingChanged
//        }
//        
//        /// Handles the value change event of the slider.
//        @objc func valueChanged(_ sender: UISlider) {
//            withAnimation {
//                self.value.wrappedValue = T(sender.value)
//                
//                onEditingChanged?(true)
//            }
//        }
//    }
//    
//    /// A binding to the value of the slider.
//    @Binding var value: T
//    
//    /// The range of the slider's values.
//    var bounds: ClosedRange<T>
//    
//    /// The color of the slider's thumb.
//    var thumbColor: Color = .ziyonText
//    
//    /// The color of the minimum track of the slider.
//    var minTrackColor: Color?
//    
//    /// The color of the maximum track of the slider.
//    var maxTrackColor: Color?
//    
//    var onEditingChanged: (Bool) -> Void
//    
//    /// Creates the slider with the specified parameters.
//    /// - Parameters:
//    ///   - value: A binding to the value of the slider.
//    ///   - bounds: The range of the slider's values.
//    ///   - thumbColor: The color of the slider's thumb.
//    ///   - minTrackColor: The color of the minimum track of the slider.
//    ///   - maxTrackColor: The color of the maximum track of the slider.
//    ///   - onEditingChanged: A closure that is called when editing begins or ends.
//    init(
//        value: Binding<T>,
//        in bounds: ClosedRange<T> = 0...1,
//        thumbColor: Color = .ziyonText,
//        minTrackColor: Color? = nil,
//        maxTrackColor: Color? = nil,
//        onEditingChanged: @escaping (Bool) -> Void = { _ in }
//    ) {
//        self._value = value
//        self.bounds = bounds
//        self.thumbColor = thumbColor
//        self.minTrackColor = minTrackColor
//        self.maxTrackColor = maxTrackColor
//        self.onEditingChanged = onEditingChanged
//    }
//    
//    /// Creates the slider's UI view.
//    public func makeUIView(context: Context) -> UISlider {
//        let slider = UISlider()
//        slider.value = Float(value)
//        slider.minimumValue = Float(bounds.lowerBound)
//        slider.maximumValue = Float(bounds.upperBound)
//        slider.minimumTrackTintColor = UIColor(minTrackColor ?? .ziyonNeutral)
//        slider.maximumTrackTintColor = UIColor(maxTrackColor ?? .ziyonLight)
//        slider.thumbTintColor = UIColor(thumbColor)
//        
//        slider.addTarget(
//            context.coordinator,
//            action: #selector(Coordinator.valueChanged(_:)),
//            for: .valueChanged
//        )
//        return slider
//    }
//    
//    /// Updates the slider's UI view with the latest value.
//    public func updateUIView(_ uiView: UISlider, context: Context) {
//        uiView.setValue(Float(value), animated: true)
//        uiView.value = Float(value)
//        
//    }
//    
//    /// Creates a coordinator instance for handling events and updates.
//    public func makeCoordinator() -> Coordinator {
//        Coordinator(value: $value, onEditingChanged: onEditingChanged)
//    }
//}
//
//#Preview {
//    VStack(alignment: .leading) {
//        Text("** Custom **Ziyon Slider**")
//        Text("With range ")
//        ZiyonCustomSlider(value: .constant(10.5),
//                          in: 0...60)
//        Text("With a differnt thumb color")
//        ZiyonCustomSlider(value: .constant(7.5),
//                          in: 0...10,
//                          thumbColor: .brown,
//                          minTrackColor: .ziyonText)
//        Text("different max/min values")
//        ZiyonCustomSlider(value: .constant(0.5),
//                          minTrackColor: .red,
//                          maxTrackColor: .blue)
//    }
//    .padding()
//    .format()
//}

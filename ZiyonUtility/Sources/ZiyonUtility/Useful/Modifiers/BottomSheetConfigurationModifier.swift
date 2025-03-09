//
//  BottomSheetConfigurationModifier.swift
//  Ziyon
//
//  Created by Elioene Silves Fernandes on 18/11/2023.
//

import SwiftUI

#if os(iOS)
public extension View {
    @available(iOS 16.4, *)
    func bottomSheetConfig(
        interactiveDismiss: Bool = .init(),
        adaption: PresentationAdaptation = .sheet,
        dragIndicatorVisibility: Visibility = .hidden,
        height: CGFloat = .zero) -> some View {
            
            presentationCompactAdaptation(adaption)
                .presentationDetents([.height(height)])
                .presentationCornerRadius(.defaultCornerRadius)
                .presentationDragIndicator(dragIndicatorVisibility)
                .frame(maxHeight: height)
                .interactiveDismissDisabled(interactiveDismiss)
                .presentationCornerRadius(.spacer30)
        }
}
#endif

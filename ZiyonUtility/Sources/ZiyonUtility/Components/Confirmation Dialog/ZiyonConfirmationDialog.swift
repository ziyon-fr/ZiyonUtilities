//
//  ZiyonConfirmationDialog.swift
//  Ziyon
//
//  Created by Elioene Leon Silves Fernandes on 03/10/2023.
//

import SwiftUI

@available(iOS 16.4, *)
public struct CustomConfirmationDialog<T:View>: ViewModifier {
    
    @Environment(\.ziyonConfirmationDialogDeleteMessageColor)
    private var cancelButtonColor
    @Environment(\.ziyonConfirmationDialogMessageColor)
    private var messageColor
    @Environment(\.confirmationDialogCancelTitle)
    private var cancelTitle
  
    @State private var viewHeight: CGFloat = .zero
    var titleKey: LocalizedStringKey?
    var titleKeyColor: Color?
    @Binding var isPresented: Bool
    private var actions: T
    
    public init(
        _ titleKey: LocalizedStringKey? = nil,
        titleKeyColor: Color? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: ()-> T
    ) {
        self.titleKey = titleKey
        self.titleKeyColor = titleKeyColor
        self.actions = actions()
        self._isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            VStack(alignment: .center, spacing: .spacer10) {
                VStack(alignment: .center, spacing: .zero) {
                    label
                    
                    Divider()
                    
                    actions
                        .foregroundColor(.ziyonPrimary)
                        .horizontalAlignment(.center)
                        .frame(height: .spacer51)
                        .background(Color.white)
                        .cornerRadius(.spacer15)
                }
                .background(Color.ziyonWhite)
                .cornerRadius(.spacer15)

                CancelButton
            }
            .padding(.horizontal, .spacer8)
            .padding(.bottom, .spacer10)
            .presentationDetents([.height(viewHeight)])
            .presentationBackground {Color.clear }
            .sizeKeyPreference { viewHeight = $0 }
            .frame(maxHeight: viewHeight)
        }
    }
}

@available(iOS 16.4, *)
extension CustomConfirmationDialog {
    
    // MARK: - Cancel Button
    private var CancelButton: some View {
        AsyncButton(role: .cancel) {
            withAnimation {
                isPresented = false
            }
        } label: {
            Text(cancelTitle)
                .foregroundColor(cancelButtonColor)
                .format(weight: .bold)
                .horizontalAlignment(.center)
                .frame(height: .spacer51)
                .background(Color.white)
                .cornerRadius(.spacer15)
                .textCase(.uppercase)
        }
    }
 
    // MARK: - Label View
    @ViewBuilder
    private var label: some View {
        if let titleKey {
            Text(titleKey)
                .format(color: messageColor, alignment: .center)
                .padding(.vertical, .spacer12)
                .padding(.horizontal, .spacer16)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - View extension
@available(iOS 16.4, *)
public extension View {
    func ziyonConfirmationDialog<T:View>(
        _ titleKey: LocalizedStringKey? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder content: ()-> T
    )-> some View {
        modifier(CustomConfirmationDialog(titleKey, isPresented: isPresented, actions: content))
    }
    
    // MARK: - picker Message Foreground modifier
        func confirmationDialogCancelButtonStyle(
            _ title: LocalizedStringKey = "useful.cancel",
             foreground: Color = .ziyonText
        ) -> some View {
            environment(\.confirmationDialogCancelTitle, title)
                .environment(\.ziyonConfirmationDialogDeleteMessageColor, foreground)
        }

    func confirmationDialogMessageColor(_ color: Color = .ziyonText)-> some View {
        environment(\.ziyonConfirmationDialogMessageColor, color)
    }

}
// MARK: Environment Value
extension EnvironmentValues {
 
    // cancel message foreground color
    var ziyonConfirmationDialogDeleteMessageColor: Color {
        get { self[ZiyonConfirmationDialogDeleteMessageColorKey.self] }
        set { self[ZiyonConfirmationDialogDeleteMessageColorKey.self] = newValue }
    }
    // Message message foreground color
    var ziyonConfirmationDialogMessageColor: Color {
        get { self[ZiyonConfirmationDialogMessageColorKey.self] }
        set { self[ZiyonConfirmationDialogMessageColorKey.self] = newValue }
    }
    
    // Message message foreground color
    var confirmationDialogCancelTitle: LocalizedStringKey {
        get { self[ZiyonConfirmationDialogMessageKey.self] }
        set { self[ZiyonConfirmationDialogMessageKey.self] = newValue }
    }
}

// MARK: Preference key
struct ZiyonConfirmationDialogDeleteMessageColorKey:EnvironmentKey {
    // default value
    static var defaultValue: Color = .ziyonText
 
}
struct ZiyonConfirmationDialogMessageKey:EnvironmentKey {
    // default value
    static var defaultValue: LocalizedStringKey = .init("useful.cancel")
 
}
struct ZiyonConfirmationDialogMessageColorKey:EnvironmentKey {
    // default value
    static var defaultValue: Color = .ziyonPrimary
 
}

@available(iOS 16.4, *)
#Preview {
    ZiyonStatefulPreview(false) { presentView in
        VStack {
            ZiyonButton("Show Alert") {
                presentView.wrappedValue.toggle()
            }
            .padding()
        }
        .verticalAlignment(.center)
        .horizontalAlignment(.center)
        .ziyonConfirmationDialog(
            "Você não poderá reverter essa operação. Tem certeza que deseja apagar?",
            isPresented: presentView
        ) {
                Text("useful.save")
        }
        .confirmationDialogCancelButtonStyle("Something")
        .confirmationDialogMessageColor(.yellow)
    }
}

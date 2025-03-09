//
//  ZiyonConfirmationDialogModifier.swift
//  Ziyon
//
//  Created by Bruno Moura on 03/10/23.
//

import SwiftUI

@available(iOS 16.4, *)
public struct ZiyonConfirmationDialogModifier<T: View>: ViewModifier {
    
    @State var viewHeight: CGFloat = .zero
    var titleKeyColor: Color?
    var titleKeyWeight: Font.Weight?
    var titleCancelButton: LocalizedStringKey?
    var cancelButtonForeground: Color?
    var cancelButtonWeight: Font.Weight?
    var titleKey: LocalizedStringKey?
    @Binding var isPresented: Bool
    private var actions: T
    
    public init(
        titleKey: LocalizedStringKey? = nil,
        titleKeyColor: Color? = nil,
        titleKeyWeight: Font.Weight? = nil,
        titleCancelButton: LocalizedStringKey? = nil,
        cancelButtonForeground: Color? = nil,
        cancelButtonWeight: Font.Weight? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> T
    ) {
        self.titleKey = titleKey
        self.titleKeyColor = titleKeyColor
        self.titleKeyWeight = titleKeyWeight
        self.titleCancelButton = titleCancelButton
        self.cancelButtonForeground = cancelButtonForeground
        self.cancelButtonWeight = cancelButtonWeight
        self._isPresented = isPresented
        self.actions = actions()
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                VStack(alignment: .center, spacing: .spacer10) {
                    VStack(spacing: .zero) {
                        if let titleKey {
                            Text(titleKey)
                                .if(titleKeyColor != nil) {
                                    $0.foregroundColor(titleKeyColor)
                                }
                                .if(titleKeyWeight != nil) {
                                    $0.format(weight: titleKeyWeight ?? .regular, alignment: .center)
                                }
                                .format(alignment: .center)
                                .padding(.vertical, .spacer12)
                                .padding(.horizontal, .spacer16)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                                .background(Color.ziyonText)
                        }
                        
                        actions
                            .foregroundColor(.ziyonAccent)
                            .horizontalAlignment(.center)
                            .frame(height: .spacer51)
                            .background(Color.white)
                            .cornerRadius(.spacer15)
                    }
                    .background(Color.ziyonWhite)
                    .cornerRadius(.spacer15)
                    
                    Button(role: .cancel) {
                        isPresented = false
                    } label: {
                        Text(titleCancelButton ?? "useful.cancel")
                            .if(cancelButtonForeground != nil) {
                                $0.foregroundColor(cancelButtonForeground)
                            }
                            .if(cancelButtonForeground == nil) {
                                $0.foregroundColor(.ziyonPrimary)
                            }
                            .if(cancelButtonWeight != nil) {
                                $0.format(weight: cancelButtonWeight ?? .black)
                            }
                            .if(cancelButtonWeight == nil) {
                                $0.format(weight: .black)
                            }
                            .horizontalAlignment(.center)
                            .frame(height: .spacer51)
                            .background(Color.white)
                            .cornerRadius(.spacer15)
                    }
                }
                .padding(.horizontal, .spacer8)
                .presentationDetents([.height(viewHeight)])
                .presentationBackground{Color.clear}
                .sizeKeyPreference { viewHeight = $0 }
            }
    }
}

@available(iOS 16.4, *)
public extension View {
    func ziyonConfirmationDialogModifier<T:View>(
        _ titleKey: LocalizedStringKey? = nil,
        titleKeyColor: Color? = nil,
        titleKeyWeight: Font.Weight? = nil,
        titleCancelButton: LocalizedStringKey? = nil,
        cancelButtonForeground: Color? = nil,
        cancelButtonWeight: Font.Weight? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> T
    ) -> some View {
        self.modifier(ZiyonConfirmationDialogModifier(
            titleKey: titleKey,
            titleKeyColor: titleKeyColor,
            titleKeyWeight: titleKeyWeight,
            titleCancelButton: titleCancelButton,
            cancelButtonForeground: cancelButtonForeground,
            cancelButtonWeight: cancelButtonWeight,
            isPresented: isPresented,
            actions: actions))
    }
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
        .ziyonConfirmationDialogModifier("Você não poderá reverter essa operação. Tem certeza que deseja apagar?",
                                         titleKeyColor: .ziyonBlue,
                                         titleKeyWeight: .black,
                                         titleCancelButton: "Something",
                                         cancelButtonForeground: .ziyonBlue,
                                         cancelButtonWeight: .regular,
                                         isPresented: presentView) {
            Text("Teste")
                .format(color: .ziyonSuccess, type: .subTitle, weight: .light)
        }
    }
}

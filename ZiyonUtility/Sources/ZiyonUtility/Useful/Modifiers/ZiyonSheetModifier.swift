//
//  ZiyonSheetModifier.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 21/07/23.
//

import SwiftUI

#if os(iOS)
public extension View {
    
    // MARK: Modifier
    func ziyonSheet<T: View>(
        isPresented: Binding<Bool>,
        hideIndicator: Bool = false,
        dismissDisabled: Bool = false,
        title: LocalizedStringKey? = nil,
        buttonTitle: LocalizedStringKey? = nil,
        buttonAction: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        return self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            ZiyonSheetModifier(
                isPresented: isPresented,
                hideIndicator: hideIndicator,
                title: title,
                buttonTitle: buttonTitle,
                buttonAction: buttonAction,
                content: content
            )
            .interactiveDismissDisabled(dismissDisabled)
        }
    }
}

public struct ZiyonSheetModifier<T: View>: View {
    
    @State private var sheetHeight: CGFloat = .spacer64
    
    private var isPresented: Binding<Bool>
    private var hideIndicator: Bool
    private var title: LocalizedStringKey?
    private var buttonTitle: LocalizedStringKey?
    private var buttonAction: (() -> Void)?
    private var content: (() -> T)
    
    private var hasToolbar: Bool {
        title != nil || buttonTitle != nil
    }
    
    public init(
        isPresented: Binding<Bool>,
        hideIndicator: Bool = false,
        title: LocalizedStringKey? = nil,
        buttonTitle: LocalizedStringKey? = nil,
        buttonAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> T
    ) {
        self.isPresented = isPresented
        self.hideIndicator = hideIndicator
        self.title = title
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                if title != nil {
                    Divider()
                }
                
                content()
                    .background {
                    GeometryReader { proxy in
                        ZStack {
                        }.onAppear {
                            withAnimation(.bouncy) {
                                updateSheetHeight(proxy.size.height)
                            }
                        }.onChange(of: proxy.size) { _, newSize in
                            withAnimation(.bouncy) {
                                updateSheetHeight(newSize.height)
                            }
                        }
                    }
                }
                .if(!hideIndicator && !hasToolbar) {
                    $0.padding(.top, .spacer52)
                }

                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                if let title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .format(type: .header, weight: .black)
                    }
                }
                
                if let buttonTitle {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            buttonAction?()
                        } label: {
                            Text(buttonTitle)
                                .format(color: .ziyonPrimary)
                        }
                    }
                }
            }
            .background(Color.ziyonWhite)
        }
        .background(.background)
        .presentationDetents([.height(sheetHeight)])
        .presentationDragIndicator(hideIndicator ? .hidden : .visible)
    }
    
    private func updateSheetHeight(_ newHeight: CGFloat) {
        withAnimation {
            self.sheetHeight = newHeight + (hideIndicator && !hasToolbar ? .zero : .spacer52)
        }
    }
}

// MARK: Preview

#Preview {

    Exemple()

}

struct Exemple: View {


     @State var presented = false
     @State var presented2 = false

    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {presented.toggle()}
                .ziyonSheet(isPresented: $presented, buttonTitle: "Teste") {
                    Text("Conteúdo")
                        .format()
                        .onTapGesture {
                            withAnimation {
                                presented2.toggle()
                            }
                        }

                    if presented2 {

                        Rectangle()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                withAnimation {
                                    presented2.toggle()
                                }
                            }

                    }
                }
        }
    }
}

#endif

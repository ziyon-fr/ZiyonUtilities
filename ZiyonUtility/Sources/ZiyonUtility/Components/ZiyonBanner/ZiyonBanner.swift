//
//  ZiyonBanner.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 08/07/23.
//

import SwiftUI

public struct ZiyonBanner: View {
    
    private let model: Model
    @Binding private var isPresented: Bool
    
    public init(model: Model, isPresented: Binding<Bool>) {
        self.model = model
        self._isPresented = isPresented
    }
    
    // MARK: Body
    public var body: some View {
        if isPresented {
            VStack {
                // To avoid navigation color being equals to Banner color
                Spacer().frame(height: 1)
                
                VStack(alignment: .leading, spacing: .spacer20) {
                    content
                    
                    if model.style == .withButton || model.style == .withTwoButton {
                        buttons
                    }
                }
                .padding(.vertical, .spacer24)
                .padding(.horizontal, .spacer20)
                .background(model.backgroundColor)
            }
            .transition(.move(edge: .leading))
        }
    }
}

extension ZiyonBanner {
    
    // MARK: Content
    private var content: some View {
        HStack(spacing: .zero) {
            Image(model.style.leadingIcon)
                .square(.spacer24)
                .foregroundColor(model.iconColor)
            
            Text(model.text)
                .format()
                .padding(.leading, .spacer20)
            
            Spacer(minLength: .spacer12)
            
            if let icon = model.style.trailingIcon {
                Button {
                    if model.iconAction != nil {
                        model.iconAction?()
                    } else {
                        withAnimation {
                            isPresented.toggle()
                        }
                    }
                } label: {
                    Image(icon)
                        .square(.spacer24)
                        .foregroundColor(.ziyonText)
                }
            } else {
                ProgressView()
            }
        }
    }
    
    // MARK: Buttons
    private var buttons: some View {
        HStack(spacing: .spacer12) {
            Button {
                model.buttonAction?()
            } label: {
                Text(model.buttonTitle)
                   
            }
            
            Button {
                if model.style == .withTwoButton {
                    model.secondButtonAction?()
                }
            } label: {
                Text(model.secondButtonTitle)
                   
            }
            .opacity(model.style == .withTwoButton ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, .spacer24 + .spacer20)
        .padding(.trailing, .spacer24)
    }
}

// MARK: Model
public extension ZiyonBanner {
    
    struct Model {
        var text: LocalizedStringKey
        var style: Style
        var iconColor: Color = .ziyonText
        var iconAction: (() -> Void)?
        var buttonTitle: LocalizedStringKey = ""
        var buttonAction: (() -> Void)?
        var secondButtonTitle: LocalizedStringKey = ""
        var secondButtonAction: (() -> Void)?
        var backgroundColor: Color = .ziyonSecondary
    }
    
    enum Style {
        case warning
        case time
        case reload
        case loading
        case error
        case success
        case withButton
        case withTwoButton
        
        var leadingIcon: AssetIcon {
            switch self {
            case .warning, .withButton, .withTwoButton: return .warning
            case .time, .reload, .loading: return .time
            case .error: return .xmarkCircle
            case .success: return .success
            }
        }
        
        var trailingIcon: AssetIcon? {
            switch self {
            case .reload: return .update
            case .loading: return nil
            default: return .xmarkSmall
            }
        }
    }
}

// MARK: Preview
struct ZiyonBanner_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .spacer8) {
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(text: "Alerta", style: .warning),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(text: "Tempo", style: .time),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(
                        text: "Recarregar",
                        style: .reload,
                        iconAction: { print("Recarregar") }
                    ),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(text: "Carregando", style: .loading),
                    isPresented: isPresented // Use to stop loading
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(text: "Erro", style: .error),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(text: "Sucesso", style: .success),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(
                        text: "Com botão",
                        style: .withButton,
                        buttonTitle: "BOTÃO",
                        buttonAction: { print("Clicou") }
                    ),
                    isPresented: isPresented
                )
            }
            
            ZiyonStatefulPreview(true) { isPresented in
                ZiyonBanner(
                    model: .init(
                        text: "Com dois botões",
                        style: .withTwoButton,
                        buttonTitle: "BOTÃO 1",
                        buttonAction: { print("Clicou") },
                        secondButtonTitle: "BOTÃO 2",
                        secondButtonAction: { print("Clicou no 2") }
                    ),
                    isPresented: isPresented
                )
            }
        }
    }
}

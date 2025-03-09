//
//  SmallAlertView.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 26/03/23.
//

import SwiftUI

public struct SmallAlertView: View {
    
    var message: SmallAlertMessage
    @State var icon: AlertMessageIcon = .error
    var dismiss: (() -> Void)?
    
    public var body: some View {
        HStack(spacing: 10) {
            if icon == .error || icon == .time || icon == .reload {
                Image(icon.rawValue)
                    .square(.spacer30)
                    .scaledToFit()
                    .foregroundColor(switchColor())
            } else {
                Image(systemName: icon.rawValue)
                    .square(.spacer30)
                    .scaledToFit()
                    .foregroundColor(switchColor())
            }
            
            Text(message.rawValue)
            
            Spacer()
            
            Button(action: {
                withAnimation { dismiss?() }
            }, label: {
                if message == .updateTaxes {
                    Image("ic-reload")
                } else { Image(systemName: "xmark").tint(.ziyonText) }
            })
        }
        .padding()
        .frame(height: 87, alignment: .leading)
        .background(Color.ziyonSecondary)
        .transition(.move(edge: .top))
    }
    
    func switchColor() -> Color {
        switch icon {
        case .sucess: return Color.green
        case .error: return Color.orange
        case .info: return Color.orange
        case .time: return .ziyonText
        case .reload: return .ziyonText
        }
    }
}

struct SmallAlertView_Previews: PreviewProvider {
    static var previews: some View {
        SmallAlertView(message: .errorFetchingTax)
    }
}

public enum SmallAlertMessage: String {
    case errorFetchingTax = "Erro ao buscar as taxas. Tente novamente mais tarde!"
    case updateTaxes = "As taxas estão desatualizadas. Atualize agora!"
    case search_bar = "Não encontramos nenhum orçamento, com o título digitado."
    case filter_applied_successfully = "Os filtros foram adicionados, com sucesso."
    case budged_created_successfully = "Um novo orçamento foi criado, com sucesso."
}

public enum AlertMessageIcon: String {
    case sucess = "checkmark.circle"
    case error = "ziyon-warning"
    case info = "info.circle"
    case time = "ic-time"
    case reload = "ic-reload"
}

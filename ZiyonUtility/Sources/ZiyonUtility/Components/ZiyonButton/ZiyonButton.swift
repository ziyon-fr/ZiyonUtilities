//
//  ZiyonButton.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 27/03/23.
//

import SwiftUI

public struct ZiyonButton: View {
    
    @Environment(\.dismiss) var dismissAction
    let title: LocalizedStringKey
    let dismiss: Bool
    let perform: (()-> Void)?
    
    public init(
        _ title: LocalizedStringKey = "Title",
        dismiss: Bool = .init(),
        perform: (()-> Void)? = nil) {
            
        self.title = title
        self.dismiss = dismiss
        self.perform = perform
    }
    
    public  var body: some View {
        Button(action: setUpAction) {
            Text(title)
        }
            
    }
        
    // MARK: Set up Action
    private func setUpAction() {
        DispatchQueue.main.async {
            if let perform {
                perform()
            }
        }
        if dismiss { dismissAction() }
    }
}

#Preview {
    VStack(spacing: .spacer20) {
      
        ZiyonButton() { }
        ZiyonButton() { }
        ZiyonButton() { }
            
    }
    .padding()
}

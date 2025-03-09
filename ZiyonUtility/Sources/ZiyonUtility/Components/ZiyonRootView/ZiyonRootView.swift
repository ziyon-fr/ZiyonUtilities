//
//  ZiyonRootView.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import Foundation
import SwiftUI

public struct ZiyonRootView<T: View, B: View>: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.rootViewBackground) private var background
    @Environment(\.rootViewTitle) private var title
        
    @Binding private var customToolbar: Bool
    
    private var icon: AssetIcon?
    private var content: T
    private var toolbar: B?
    
    public init(
        _ icon: AssetIcon? = nil,
        customToolbar: Binding<Bool> = .constant(false),
        @ViewBuilder content: (() -> T),
        @ViewBuilder toolbar: (() -> B) = { EmptyView() }
    ) {
        self.icon = icon
        self._customToolbar = customToolbar
        self.content = content()
        self.toolbar = toolbar()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            
            if !title.key.isEmpty {
                
            Text(title)
                .format(type: .title, weight: .black)
                .padding(.top, .spacer24)
                .padding(.horizontal, .spacer20)
        }
            content
            
        }
        .contentShape(.containerRelative)
        .background(background)
        .if(customToolbar) {
            $0.toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    toolbar
                }
            }
        }
        .if(!customToolbar) {
            $0.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let icon {
                        Image(icon)
                            .foregroundColor(.ziyonText)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolbar
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ZiyonStatefulPreview(true) { isPresented in
        ZiyonRootView {
            Spacer()
            
            Text("View")
                .frame(maxWidth: .infinity)
            
            Spacer()
        } toolbar: {
            Button("Toolbar") { }
        }
    }
}

//
//  DismissButton.swift
//  ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

//MARK: Dismiss Button
public struct DismissButton: View {
    var icon: String = "ziyon-chevron-backward"
    @Environment(\.dismiss) var dismiss
    public var body: some View {
        Button {
            dismiss()
        } label: {
            Image(icon)
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}

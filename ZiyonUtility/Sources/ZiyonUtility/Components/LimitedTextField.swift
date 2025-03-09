//
//  LimitedTextField.swift
//
//
//  Created by Elioene Silves Fernandes on 01/04/2024.
//

import SwiftUI

public struct LimitedTextField: View {
    
    @Binding var text: String
    /// View Properties
    var axis: Axis = .vertical
    @State private var presentYeyboard: Bool = .init()
    /// Configuration
    var config: LimitedTextfieldConfig
    
    public var body: some View {
        VStack(alignment: config.progressConfig.alignment) {
            ZStack(alignment: .top) {
                TextField("", text: $text, axis: axis)
                    .textFieldStyle(.ziyon(foretext: "Name", icon: "eye"))
                    .autocorrectionDisabled(true)
                    .format(type: .small, weight: .light)
                    .frame(height: config.autoResizes ? 0 : nil)
                    .onChange(of: text) { newValue in
                        guard !config.allowsExcessTyping else { return }
                        text = String(text.prefix(config.limit))
                    }
                    .onChange(of: config.allowsExcessTyping) { newValue in
                        if !newValue {
                            text = String(text.prefix(config.limit))
                        }
                    }
                    .onTapGesture {
                        /// Show Keyboard
                        presentYeyboard = true
                }
            }
        }
    }
    var progress: CGFloat {
        return max(min(CGFloat(text.count) / CGFloat(config.limit), 1), 0)
    }
    
    var progressColor: Color {
        return progress < 0.6 ? config.tint : progress == 1.0 ? .red : .orange
    }
}

struct LimitedTextfieldConfig {
    var limit: Int
    var tint: Color = .blue
    var autoResizes: Bool = false
    var allowsExcessTyping: Bool = false
    var progressConfig: ProgressConfig = .init()
    var borderConfig: BorderConfig = .init()
}
struct ProgressConfig {
    var showsRing: Bool = false
    var showsText: Bool = true
    var alignment: HorizontalAlignment = .trailing
}

struct BorderConfig {
    var show: Bool = true
    var radius: CGFloat = 12
    var width: CGFloat = 0.8
}

#Preview {
    ZiyonStatefulPreview("String") { text in
        LimitedTextField(text: text, config: .init(limit: 6))
            .padding()
    }

}



 extension TextFieldStyle  where Self == ZiyonTextFieldStyle {

/// `ziyon` default `design system` textfield style
     public static func ziyon(foretext: String? = nil, icon: String? = nil)-> ZiyonTextFieldStyle {
         Self(foretext, icon: icon)
     }
}

/// The  ziyon default text field style, based on UX/UX design context.
///
/// The default ziyon  style represents the recommended style based on the

public struct ZiyonTextFieldStyle: TextFieldStyle {

    let foretext: String?
    let icon: String?
    public init(_ foretext: String? = nil, icon: String? = nil) {
        self.foretext = foretext
        self.icon = icon
    }
    @ViewBuilder
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: .spacer12) {
            if let foretext {
                Text(foretext)
                    .format()
            }
            configuration
                .body
            if let icon {
                Spacer()
                Image(systemName: icon)
                    .square(.spacer20)
            }

        }.defaultRadialBackground()
    }
}


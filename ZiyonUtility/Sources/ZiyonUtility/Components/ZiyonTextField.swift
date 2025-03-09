//
//  ZiyonTextField.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 09/08/23.
//

import SwiftUI

public struct ZiyonTextField: View {

    private var foretext: String?
    public var placeholder: String?
    @Binding private var text: String
    private var textColor: Color
    private var textType: TextType
    private var textWeight: Font.Weight
    private var placeholderColor: Color
    private var placeholderType: TextType
    private var placeholderWeight: Font.Weight
    private var mask: Mask?
    private var isValid: Bool
    private var hideDivider: Bool
    
    public init(
        foretext: String? = nil,
        _ placeholder: String? = nil,
        text: Binding<String>,
        textColor: Color = .ziyonText,
        textType: TextType = .caption,
        textWeight: Font.Weight = .regular,
        placeholderColor: Color = .ziyonText,
        placeholderType: TextType = .caption,
        placeholderWeight: Font.Weight = .thin,
        mask: Mask? = nil,
        isValid: Bool = true,
        hideDivider: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.textColor = textColor
        self.textType = textType
        self.textWeight = textWeight
        self.placeholderColor = placeholderColor
        self.placeholderType = placeholderType
        self.placeholderWeight = placeholderWeight
        self.mask = mask
        self.isValid = isValid
        self.hideDivider = hideDivider
    }
    
    // MARK: Body
    public var body: some View {
        VStack(spacing: .spacer12) {
            ZStack(alignment: .leading) {
                if let placeholder, text.isEmpty {
                    Text(placeholder.localized)
                        .format(
                            color: isValid ? placeholderColor : .ziyonError,
                            type: placeholderType,
                            weight: placeholderWeight
                        )
                }
                
                TextField("", text: $text)
                    .foregroundColor(isValid ? textColor : .ziyonError)
                    .font(.roboto(type: textType, weight: textWeight))
                    .onChange(of: text) { newText in
                        if let mask {
                            text = mask.formatText(newText)
                        }
                    }
            }
            
            if !hideDivider {
                Divider()
                    .frame(height: 2)
                    .overlay(isValid ? textColor : .ziyonError)
            }
        }
    }
}

// MARK: Mask
extension ZiyonTextField {
    
    public struct Mask {
        let formats: [String]
        let allowedCharacters: String
        
        public init(_ formats: String..., allowedCharacters: String) {
            self.allowedCharacters = allowedCharacters
            self.formats = formats.sorted(by: {
                $0.components(separatedBy: "#").count < $1.components(separatedBy: "#").count
            })
        }
        
        func formatText(_ text: String) -> String {
            var allowedString = text.extractCharacters(allowedCharacters)
            
            guard let currentFormat = formats.first(where: {
                $0.components(separatedBy: "#").count - 1 >= allowedString.count
            }) ?? formats.last else { return allowedString }
            
            let result = currentFormat.map { character in
                if allowedString.isEmpty { return "" }
                
                if character == "#" {
                    if let newCharacter = allowedString.first {
                        allowedString.removeFirst()
                        return String(newCharacter)
                    } else {
                        return ""
                    }
                } else {
                    return String(character)
                }
            }
            return result.joined()
        }
    }
}

// MARK: Preview
struct ZiyonTextField_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .spacer20) {
            ZiyonStatefulPreview("") { text in
                ZiyonTextField(text: text)
            }
            
            ZiyonStatefulPreview("") { text in
                ZiyonTextField("Placeholder", text: text)
            }
            
            ZiyonStatefulPreview("Teste") { text in
                ZiyonTextField(
                    "Placeholder",
                    text: text,
                    textColor: .ziyonAccent,
                    textType: .header,
                    textWeight: .black,
                    placeholderColor: .ziyonText.opacity(0.4),
                    placeholderType: .header,
                    placeholderWeight: .black
                )
            }
            
            ZiyonStatefulPreview("Erro") { text in
                ZiyonTextField(
                    "Placeholder",
                    text: text,
                    isValid: (text.wrappedValue != "Erro")
                )
            }
            
            ZiyonStatefulPreview("") { text in
                ZiyonTextField(
                    "Placeholder",
                    text: text,
                    textType: .header,
                    textWeight: .black,
                    placeholderColor: .ziyonText.opacity(0.4),
                    placeholderType: .header,
                    mask: .init("+## (##) #####-####", allowedCharacters: .numbersPattern)
                )
            }
        }
        .padding(.horizontal, .spacer20)
    }
}

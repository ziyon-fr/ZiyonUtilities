//
//  ZiyonPicker.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 25/11/2023.
//

import SwiftUI


enum Options:String, CaseIterable {
    case personal = "Raw Value"
    case business = "Encoding"
}
struct ZiyonPickerPreview: View {
    
    @State private var selection: Options = .personal
    @State private var options: [String] = ["Personal", "Business"]
    
    var body: some View {
        VStack(alignment:.leading, spacing: 20) {
 
            Text("Array of Strings: **\(selection)**")
            ZiyonPicker(selection: $selection, options: Options.allCases)
                .ziyonPickerForeground(.ziyonOrange)
            
            TabView(selection: $selection){
                Rectangle()
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .tag(Options.personal)
                
                Rectangle()
                    .fill(.red)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .tag(Options.business)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
        }.padding()
    }
}

public struct ZiyonPicker<SelectionValue: Hashable>: View {
    
    @Namespace var animation
    
    @Environment(\.ziyonPickerBackgroundColor)
    private var background
    @Environment(\.ziyonPickerForegroundColor)
    private var foreground
    
    private var selection: Binding<SelectionValue>
    private var options: [SelectionValue]
    
   public  init(
        selection: Binding<SelectionValue>,
        options: [SelectionValue]
    ) {
        self.selection = selection
        self.options = options
    }
    
    @MainActor public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let buttonWidth = width / CGFloat(options.count)
            
            RoundedRectangle(cornerRadius: .spacer10)
                .fill(background)
                .frame(width: width, height: .spacer36)
                .overlay {
                    HStack(spacing: .zero) {
                        ForEach(options, id: \.hashValue) {  value in
                            pickerButton(value, width: buttonWidth)
                        }
                    }
                    .frame(width: width)
                }
        }
        .frame(height: .spacer36)
        .animation(.easeInOut(duration: 0.5), value: selection.wrappedValue)
    }
}


public extension ZiyonPicker {
   // MARK: Picker Button
   
    private func pickerButton(_ value: SelectionValue,  width: CGFloat) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                selection.wrappedValue = value
            }
        } label: {
            if selection.wrappedValue == value {
                Text(String(describing: value).capitalized)
                    .format(color: .ziyonWhite)
                    .frame(width: width, height: .spacer36)
                    .background {
                        Rectangle()
                            .foregroundColor(foreground)
                            .cornerRadius(.spacer8)
                            .shadow(color: .ziyonText.opacity(0.3), radius: 7.5, x: 0, y: 5)
                            .matchedGeometryEffect(id: "ZiyonPicker", in: animation)
                    }
            } else {
                Text(String(describing: value).capitalized)
                    .format()
                    .frame(width: width, height: .spacer36)
                    
            }
        }.buttonStyle(.default())
    }
}


public extension View {
    // MARK: Picker Background color
   func ziyonPickerBackground(_ color: Color)-> some View {
      environment(\.ziyonPickerBackgroundColor, color)
    }
    
    // MARK: Picker foreground color
   func ziyonPickerForeground(_ color: Color)-> some View {
      environment(\.ziyonPickerForegroundColor, color)
    }
}

// MARK: Ziyon Picker Background Color Key
struct ZiyonPickerBackgroundColorKey: EnvironmentKey {
    static var defaultValue: Color = .ziyonSecondary
}
// MARK: Ziyon Picker Background Color Key
struct ZiyonPickerForegroundColorKey: EnvironmentKey {
    static var defaultValue: Color = .ziyonText
}

// MARK: Environment Values
extension EnvironmentValues {
    // background
    var ziyonPickerBackgroundColor: Color {
        get { self[ZiyonPickerBackgroundColorKey.self] }
        set { self[ZiyonPickerBackgroundColorKey.self] = newValue }
    }
    // foreground
    var ziyonPickerForegroundColor: Color {
        get { self[ZiyonPickerForegroundColorKey.self] }
        set { self[ZiyonPickerForegroundColorKey.self] = newValue }
    }
}



#Preview {
    ZiyonPickerPreview()
}

//
//  ZiyonMonthCalendar.swift
//
//
//  Created by Elioene Silves Fernandes on 10/04/2024.
//

import SwiftUI

public struct ZiyonMonthCalendar: View {
    
    @Binding var date: Date
    @State private var datePlaceholder: Int = .zero
    @State private var tempDate: Date = .now
    
    @Environment(\.ziyonMonthCalendarSaveButton) private var save
    @Environment(\.ziyonMonthCalendarCancelButton) private var cancel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    @Namespace private var animation
    
    public init(date: Binding<Date>) {
        self._date = date
       
    }
        
    public var body: some View {
        
        VStack {
            /// `Header`
            CalendarHeader
            
            Divider()
            
            /// `Months`
            CalendarMonthSelector()
            
            /// `Action Buttons`
            
            Spacer()
            
            /// Buttons`
            ActionButtons()
        }
        .verticalAlignment(.topLeading)
        .onAppear {
            tempDate = date
            datePlaceholder = date.month
           
        }
        .onDisappear {
            datePlaceholder = .zero
        }
    }
}

// MARK: View Extension
private extension ZiyonMonthCalendar {
    
    // MARK:
    private func ActionButtons()-> some View {
        HStack(spacing: .spacer20) {
            ZiyonButton(cancel, dismiss: true)
                .buttonStyle(.ziyon(color: .ziyonSecondary))
            
            ZiyonButton(save, dismiss: true) { date = tempDate }
            .buttonStyle(.ziyon())
            .format(color: .ziyonWhite)
        }
        .padding(.horizontal,.spacer16)
        .verticalAlignment(.bottom)
    }
    // MARK:
    private var CalendarHeader: some View {
        HStack {
            Image(.ziyonCalendarPlus)
                .square(.spacer24)
            
            Text(tempDate.format(as: .dateMonthYearFormat))
                .format(weight: .black)
                .textTransition(from: .init(date.day))
               
            
            Spacer()
            
            CalendarYearSelector()
        }
        .padding(.horizontal, .ziyonDefaultPadding)
    }
    
    // MARK:
    @ViewBuilder
    private func CalendarYearSelector()-> some View {
        HStack {
            Button {
                withAnimation {
                    tempDate.year -= 1
                }
            } label: {
                Image(.ziyonChevronBackward)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(.default(scale: 0.5))
            
            Text(tempDate.format(as: .year))
                .format(type: .header)
                .textTransition(from: .init(date.year))
            
            Button {
                withAnimation {
                    tempDate.year += 1
                }
            } label: {
                Image(.ziyonChevronForward)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(.default(scale: 0.5))
        }
            
        .foregroundColor(.ziyonText)
    }
    // MARK:
    @ViewBuilder
    private func CalendarMonthSelector()-> some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: .spacer40){
            
            ForEach(getMonths().indices, id: \.self) { index in
                
                let range = index + 1
                
                let isSelected = (datePlaceholder == range)
              
                Button {
                    withAnimation {
                        datePlaceholder = range
                        tempDate.month = range
                    }
                } label: {
                    Text(getMonths()[index].capitalized.replacingOccurrences(of: ".", with: ""))
                        .format(color: Date().month == range || datePlaceholder == range ? .ziyonBlue : .ziyonPrimary)
                        .horizontalAlignment(.center)
                        .background {
                            if isSelected {
                                Circle()
                                    .fill(.ziyonSecondary)
                                    .frame(height: 42)
                                    .matchedGeometryEffect(id: "ZiyonMonthCalendarID", in: animation)
                            }
                        }
                    
                }
                .buttonStyle(.default())
            }
            .padding(.horizontal, .spacer20)
        }
        .padding(.top, .spacer40)
    }
    // MARK:
    private func getMonths()->[String] {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter.shortMonthSymbols ?? .init()
    }
}

struct ZiyonMonthCalendarPreview: View {
    
    @State private var date: Date = .now
    
    var body: some View {
        ZiyonMonthCalendar(date: $date)
    }
}
#Preview {
    ZiyonMonthCalendarPreview()
        .monthCalendarButtonFormat(cancel: "Cancelar", save: "Save")
}

fileprivate struct ZiyonMonthCalendarCancelButton: EnvironmentKey {
    static var defaultValue: LocalizedStringKey = .init("useful.cancel")
}
fileprivate struct ZiyonMonthCalendarSaveButton: EnvironmentKey {
    static var defaultValue: LocalizedStringKey = .init("useful.save")
}

public extension EnvironmentValues {
    var ziyonMonthCalendarCancelButton: LocalizedStringKey {
        get { self[ZiyonMonthCalendarCancelButton.self] }
        set { self[ZiyonMonthCalendarCancelButton.self] = newValue }
    }
    var ziyonMonthCalendarSaveButton: LocalizedStringKey {
        get { self[ZiyonMonthCalendarSaveButton.self] }
        set {self[ZiyonMonthCalendarSaveButton.self] = newValue}
    }
}

public extension View {
    
    @ViewBuilder
    func monthCalendarButtonFormat(
        cancel: LocalizedStringKey = "useful.cancel",
        save: LocalizedStringKey = "useful.save"
    )-> some View {
        self.environment(\.ziyonMonthCalendarCancelButton, cancel)
            .environment(\.ziyonMonthCalendarSaveButton, save)
    }
}

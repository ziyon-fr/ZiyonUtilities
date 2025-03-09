//
//  ScheduleCalendar.swift
//  ZiyonUtility
//
//  Created by Elioene Silves Fernandes on 18/02/2025.
//

import SwiftUI

// Configurar tradução da data
public struct ScheduleCalendar: View {
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @Binding var isAllDay: Bool
   
    @State private var viewHeight: CGFloat? = nil
    @State private var selectedDate: ScheduleCalendarOption = .date
    
    var presentCalendar: Bool {
       
        if isAllDay || selectedDate == .date {
            return true
        }
        return false
    }
    
    var dateSelection: Binding<Date> {
        
        switch selectedDate {
            
        case .date, .startingHour:
            return $startDate
            
        case .endHour:
            return $endDate
        }
    }
    
    public init(
        startDate: Binding<Date>,
        endDate: Binding<Date>,
        isAllDay: Binding<Bool>) {
        self._startDate = startDate
        self._endDate = endDate
        self._isAllDay = isAllDay
        self.viewHeight = viewHeight
        self.selectedDate = selectedDate
    }
    
    public var body: some View {
        
        VStack(spacing: .spacer12) {
           
            AllDayButton()
                .padding(.top, .spacer40)
                .onChange(of: isAllDay) { _, newValue in

                        withAnimation {
                            startDate.hour = 0
                            startDate.minute = 0
                            endDate.hour = 0
                            endDate.minute = 0
                        }

                }
            
            if !isAllDay {

                Dates
                    .transition(
                        .blurReplace()
                    )
            }
            
            DatePicker("", selection: dateSelection ,displayedComponents:  presentCalendar == true ? [.date] : [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .format()
                .contentTransition(.opacity)
                .transition(.opacity)
               
        }
        .sizeKeyPreference { viewHeight = $0 }
        .verticalAlignment(.top)
        .horizontalAlignment(.center)
        .presentationDetents([.medium, .large, .height(viewHeight ?? .zero)])
        .presentationDragIndicator(.visible)

        }
        
        
}

extension ScheduleCalendar {
    
    // MARK:
    private func AllDayButton()-> some View {
        HStack {
            ZiyonLabel(type: .hide,
                       text: "scheduleCalendar.allDay.title".localized,
                       leadingIcon: "clock")
            
            Spacer()
            
            ZiyonToggle(isOn: $isAllDay)
        }
        .defaultRadialBackground()
        
        .padding(.horizontal, .ziyonDefaultPadding)
    }
    
    private var Dates: some View {
        VStack {
            
            HStack(spacing: .spacer12) {
                /// `calendar.circle`
              Image(systemName: "calendar.circle")
                Text("scheduleCalendar.date.title")
                    .format()
                Spacer()
                
                Button {
                    selectedDate = .date
                    
                } label: {
                    Text(startDate.format(as: .dateDecriptiveFormat))
                        .format(color:selectedDate == .date ? .ziyonBlue : .ziyonText)
                }
                
            }
            
            Divider()
            
            HStack(spacing: .spacer12) {
                /// `calendar.circle`
              Image(systemName: "clock")
                Text("scheduleCalendar.start.title")
                    .format()
                Spacer()
                
                Button {
                    selectedDate = .startingHour
                    
                } label: {
                    Text(startDate.format(as: .hourMinuteFormat))
                        .format(color:selectedDate == .startingHour ? .ziyonBlue : .ziyonText)
                }
                
            }
            
            Divider()
            
            HStack(spacing: .spacer12) {
                /// `clock`
              Image(systemName: "clock")
                    .scaleEffect(x: -1)
                    
                Text("scheduleCalendar.end.title")
                    .format()
                Spacer()
                
                Button {
                    selectedDate = .endHour
                } label: {
                    Text(endDate.format(as: .hourMinuteFormat))
                        .format(color: selectedDate == .endHour ? .ziyonBlue : .ziyonText)
                }
            }
        }
        .defaultRadialBackground()
        .padding(.horizontal,.ziyonDefaultPadding)
    }
}

enum ScheduleCalendarOption {
    case date
    case startingHour
    case endHour
}

#Preview {
    PreviewHelpers()
}


struct PreviewHelpers: View {

    @State var isAllday: Bool = false

    var body: some View {
        VStack {
            
        }
        .verticalAlignment(.topLeading)
        .sheet(isPresented: .constant(true), content: {
            ScheduleCalendar(startDate: .constant(.now), endDate: .constant(.now), isAllDay:$isAllday)
                .transition(.identity)
        })
    }
}

struct ZiyonLabel: View {
    let text: String
    let textColor: Color
    let leadingIcon:String
    let trailingIcon:String
    let type: ZiyonLabelType
    let isImage: Bool
    
    
    init(
        type: ZiyonLabelType = .double,
        text: String,
        textColor: Color = .ziyonText,
        isImage: Bool = .init(),
        leadingIcon: String = .init(),
        trailingIcon: String = "chevron.right"
       
    ) {
        self.type = type
        self.text = text
        self.textColor = textColor
        self.isImage = isImage
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        
    }
    var body: some View {
        HStack(alignment: .center) {
            
            if [.double,.hide].contains(type) {
                if isImage {
                    
                    Image(leadingIcon)
                        .square(.spacer24)
                        
                } else {
                    Image(systemName: leadingIcon)
                        .square(.spacer24)
                        .tint(.black)
                }
                
            }
            Text(text)
                .format(color: textColor)
            
            if type == .double {
                Spacer()
            }
            
            if  type != .hide {
                if isImage {
                    Image(trailingIcon)
                        .square(.spacer15)
                        
                } else {
                    Image(systemName: trailingIcon)
                        .square(.spacer15)
                        .tint(.black)
                }
            }
            
               
            
        }
    }
}
enum ZiyonLabelType {
    
    case simple
    
    case double
    
    case hide
}

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
    @State private var selectedDateType: ScheduleCalendarOption?
    @State private var presentationMode: PresentationDetent = .medium

    
    public init(
        startDate: Binding<Date>,
        endDate: Binding<Date>,
        isAllDay: Binding<Bool>) {
        self._startDate = startDate
        self._endDate = endDate
        self._isAllDay = isAllDay
        self.viewHeight = viewHeight
        self.selectedDateType = selectedDateType
    }
    
    public var body: some View {
        
        VStack(spacing: .spacer12) {
           
            AllDayButton()
                .padding(.top, .spacer40)
                .onChange(of: isAllDay) { _, newValue in
                    if newValue {
                        withAnimation {
                            startDate.hour = 0
                            startDate.minute = 0
                            endDate.hour = 0
                            endDate.minute = 0
                        }
                    }
                }
            
                Dates.transition(.blurReplace())

        }
        .verticalAlignment(.top)
        .horizontalAlignment(.center)
        .presentationDetents([.medium, .large],selection: $presentationMode)
        .presentationCornerRadius(.defaultCornerRadius)
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
        .padding(.horizontal, .ziyonDefaultPadding)
    }
    
    private var Dates: some View {
        VStack(spacing: .spacer12) {


            DateRow(for: $startDate, as: .startingDate, and: .startingHour)

            Divider()

            DateRow(for: $endDate, as: .endDate, and: .endHour)

        }
        .defaultRadialBackground()
        .padding(.horizontal,.ziyonDefaultPadding)
    }

    private func DateRow(for date: Binding<Date>, as dateType: ScheduleCalendarOption, and startingHour: ScheduleCalendarOption)-> some View {
        // MARK: Starting Date
        VStack {
            HStack(spacing: .spacer4) {
                /// `calendar.circle`
                Image(systemName: dateType.iconName)
                    .rotationEffect(.init(degrees:  dateType == .startingDate ? 90 : .zero))
                    .padding(.trailing, .spacer8)
                /// scheduleCalendar.date.title"
                Text(dateType.rawValue.localized)
                    .format()

                Spacer()

                // Date
                Button  {
                    withAnimation {
                        selectedDateType =  (selectedDateType == dateType) ? nil : dateType
                    }
                } label: {
                    Text(date.wrappedValue.format(as: .dateDecriptiveFormat))
                        .format(color:selectedDateType == dateType ? .ziyonBlue : .ziyonText, weight: .light)
                }
                .defaultRadialBackground(color:.white, padding: .spacer10)
                .buttonStyle(.default())

                // Hour
                if !isAllDay {
                    Button  {
                        withAnimation {
                            selectedDateType =  (selectedDateType == startingHour) ? nil : startingHour
                        }
                    } label: {
                        Text(date.wrappedValue.format(as: .hourMinuteFormat))
                            .format(color:selectedDateType == startingHour ? .ziyonBlue : .ziyonText, weight: .light)
                    }
                    .defaultRadialBackground(color:.white, padding: .spacer10)
                    .buttonStyle(.default())
                }

            }

            if let selectedDateType, (selectedDateType == dateType) || selectedDateType == startingHour {

                DatePicker("",selection: date,
                    displayedComponents: selectedDateType == dateType ? [.date] : [.hourAndMinute])
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .contentTransition(.opacity)
            }

        }
    }
}

enum ScheduleCalendarOption: String {

    case startingDate = "Start"
    case endDate = "End"
    case startingHour
    case endHour

    var iconName: String {
        return "clock"
    }
}

#Preview {
    PreviewHelpers()
}


struct PreviewHelpers: View {

    @State var isAllday: Bool = false
    @State var startdate: Date = .now
    @State var endDate: Date = .now

    var body: some View {
        VStack {
            
        }
        .verticalAlignment(.topLeading)
        .sheet(
isPresented: .constant(true),
content: {
    ScheduleCalendar(startDate: $startdate,endDate: $endDate,
        isAllDay:$isAllday
    )
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

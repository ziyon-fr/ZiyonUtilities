//
//  ZiyonDatePicker.swift
//  ZIYON Support
//
//  Created by Elioene Silves Fernandes on 03/12/2023.
//

import SwiftUI

public struct ZiyonDatePicker: View {
    
    @Binding var date: Date
    
    
    public var body: some View {
        
        NavigationLink(destination: {
            ZiyonCalendar(date: $date)
                
        }) {
            HStack {
                Text(date.format(as: .numberDateFormat))
                    .format(color: .ziyonBlue)
                    .textTransition(from: .init(date.day))
                
                Spacer()
                Image(systemName: "calendar.badge.plus")
                    .foregroundStyle(Color.ziyonPrimary)
            }
            .padding(.spacer16)
            .ziyonTextFieldStyle()
        }
    }
}

public struct ZiyonCalendar: View {
    
    @StateObject private var observer = ZiyonDatePickerObserver()
    @Binding var date: Date
    @Namespace private var animation

    @Environment(\.ziyonMonthCalendarSaveButton) private var save
    @Environment(\.ziyonMonthCalendarCancelButton) private var cancel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    public init(date: Binding<Date>) {
        self._date = date
    }
    public var body: some View {
            VStack {
                CalendarHeader
                    .padding(.top, .spacer20)
                Divider().padding(.bottom,.spacer40)
                CalendarMonthSelector()
                CalendarDaySelector()
                ActionButtons()
            }
            .verticalAlignment(.topLeading)
            .navigationBarBackButtonHidden()
        
    }
}

// MARK: -
extension ZiyonCalendar {
    // MARK:
    private var CalendarHeader: some View {
        HStack {
            Image(.ziyonCalendarPlus)
                .square(.spacer24)
            
            Text(observer.date.format(as: .numberDateFormat))
                .format(weight: .black)
                .textTransition(from: .init(observer.date.day))
               
            
            Spacer()
            
            CalendarYearSelector()
        }
        .padding(.horizontal, .ziyonDefaultPadding)
    }
    
    // MARK:
    private func CalendarYearSelector()-> some View {
        HStack {
            Button {
                withAnimation {
                    observer.date.year -= 1
                }
            } label: {
                Image(.ziyonChevronBackward)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(.default(scale: 0.5))
            
            Text(observer.date.format(as: .year))
                .format(type: .header)
                .textTransition(from: .init(observer.date.year))
            
            Button {
                withAnimation {
                    observer.date.year += 1
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
        ScrollView(.horizontal) {
            ScrollViewReader { proxy in
                HStack(spacing: .spacer20) {
                    ForEach(observer.getMonthName().indices, id: \.self) { index in
                        
                        let range = index + 1
                        let isSelected = (observer.date.month == range)
                        
                        VStack {
                            Button {
                                withAnimation {
                                    observer.date.month = range
                                    
                                }
                                observer.currentSelectedMonth = range
                                
                            } label: {
                                Text(observer.getMonthName()[index].capitalized.replacingOccurrences(of: ".", with: ""))
                                    .id(range) // triggers view Update
                            }
                            .buttonStyle(.default())
                            .format(
                                color: isSelected ? .ziyonBlue : .ziyonText,
                                weight: isSelected ? .black : .light)
                            .contentTransition(.identity)
                           
                                Capsule()
                                    .fill(Color.ziyonBlue)
                                    .frame(width: .spacer12, height: 5)
                                    .matchedGeometryEffect(id: "Capsule_ID", in: animation, isSource: isSelected)
                          
                        }
                    }
                }
                .onAppear {
                    if observer.date != date {
                        observer.date = date
                    }
                    withAnimation {
                        proxy.scrollTo(date.month, anchor: .center)

                    }
                }
                .padding(.horizontal,.spacer16)
                .onChange(of: observer.date.month) { oldValue, newValue in
                    withAnimation {
                        proxy.scrollTo(observer.date.month, anchor: .center)
                    }
                    print(newValue)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, .spacer28)
    }
    
    // MARK:
    @ViewBuilder
    private func CalendarDaySelector()-> some View {
        VStack(alignment: .leading ,spacing: .zero) {
            LazyVGrid(columns: columns, spacing: .zero) {
                ForEach(observer.getComponents().shortDays, id: \.self) { day in
                    Text(day.capitalized.replacingOccurrences(of: ".", with: ""))
                        .format(weight:.black)
                }
            }
            .padding(.horizontal,.spacer16)
            
            LazyVGrid(columns: columns, spacing: .zero) {
                ForEach(observer.extractDays(), content: SelectDayButton)
                    .transition(.identity)

                
            }.padding(.horizontal,.spacer16)
        }
    }
    
    // MARK:
    func SelectDayButton(value: DateObject)-> some View {
        Button {
            withAnimation(.default){
                observer.date.day = value.date.day
            }
            
            
        } label: {
            VStack {
                if value.day != -1 {
                    
                    let isSameDay = (observer.date.day == value.date.day)
                    
                    if isSameDay {
                        
                        Text(value.day, format: .number)
                            .format(color: .ziyonBlue ,type: .body)
                            .frame(width: .spacer45, height: .spacer45, alignment: .center)
                            .background(isSameDay ? Color.ziyonSecondary : .clear ,in: .circle)
                            .matchedGeometryEffect(id: "days_animation_ID", in: animation, isSource: date.day != value.date.day)
                        
                    }
                    else {
                        Text(value.day, format: .number)
                            .format(color: date.day == value.date.day ? .ziyonBlue: .ziyonText, type: .body)
                            .frame(width: .spacer45, height: .spacer45, alignment: .center)
                            .background(.clear ,in: .circle)
                        
                    }
                }
            }
        }
        .buttonStyle(.default())
    }
    
    // MARK:
    private func ActionButtons()-> some View {
        HStack(spacing: .spacer20) {
            ZiyonButton(cancel, dismiss: true)
                .buttonStyle(.ziyon(color: .ziyonSecondary))
            
            ZiyonButton(save, dismiss: true) {
                    date = observer.date
                   
                }
            .buttonStyle(.ziyon())
            .format(color: .ziyonWhite)
        }
        .padding(.horizontal,.spacer16)
        .verticalAlignment(.bottom)
    }
}


fileprivate class ZiyonDatePickerObserver: ObservableObject {
    
    @Published var currentSelectedMonth: Int = .zero
    @Published var date: Date = .now
    
    // MARK:
    func extractDays() -> [DateObject] {
        let calendar = Calendar.autoupdatingCurrent

        let currentMonth = dateWithUpdatedMonth()
        
        var days = currentMonth.getCurrentMonthDate().compactMap { date -> DateObject in
            // extracting day
            let day = calendar.component(.day, from: date)
            return DateObject(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first!.date)
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateObject(day: -1, date: Date()), at: .zero)
        }
        return days
    }
    
    // MARK:
    func dateWithUpdatedMonth() -> Date {
        
        let calendar = Calendar.current
        
        guard let extractedMonthByValue = calendar
            .date(
                byAdding: .month,
                value: self.currentSelectedMonth,
                to: Date()) else {
            return .init()
        }
        return extractedMonthByValue
        
    }
    
    
    // MARK:
    func getMonthName() -> [String] {
        
        let stringMonthFormat = DateFormatter()
        stringMonthFormat.locale = .autoupdatingCurrent
        return stringMonthFormat.shortMonthSymbols ?? .init()
    }
        
    // MARK:
    func getComponents() -> (shortDays: [String], numberedDays: [Int]) {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.weekday], from: dateWithUpdatedMonth())
        
        guard let weekday = components.weekday else {
            return ([], [])
        }
        
        // Get short days (e.g., Mon, Tue, etc.)
        let shortDaysFormatter = DateFormatter()
        shortDaysFormatter.locale = .autoupdatingCurrent
        shortDaysFormatter.dateFormat = "E"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = .year
        
        let shortDays = (1...7).compactMap { calendar.date(byAdding: .day, value: $0 - weekday, to: dateWithUpdatedMonth()) }
            .map { shortDaysFormatter.string(from: $0) }
        
        // Get numbered days (1, 2, 3, etc.)
        let numberedDays = (1...7).map { calendar.date(byAdding: .day, value: $0 - weekday, to: dateWithUpdatedMonth())}
            .compactMap { $0?.day }
        
        return (shortDays, numberedDays)
    }
}

struct DateObject: Identifiable {
    var id = UUID().uuidString
    let day: Int
    let date: Date
}

//#Preview {
//    ZiyonStatefulPreview(Date()) { date in
//        NavigationStack {
//            ZiyonCalendar(date: date)
//        }
//    }
//}

#Preview {
    ZiyonStatefulPreview(Date()) { date in
        NavigationStack {
//            Button("Calendar") {
//
//            }
//            .sheet(isPresented: .constant(true)){
                ZiyonCalendar(date: date)
                .environment(
                    \.locale,
                     .init(components: .init(identifier: "FR"))
                )
//            }

        }
    }
}

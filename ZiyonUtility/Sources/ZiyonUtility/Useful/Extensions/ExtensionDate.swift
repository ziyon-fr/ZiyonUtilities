//
//  ExtensionDate.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 11/03/23.
//

import SwiftUI

public extension Date {
    // MARK: Components
    var components: DateComponents {
        Calendar.brazilian.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: self
        )
    }
    var year: Int {
        get {
            components.year ?? .zero
        }
        set(year) {
            var newComponents = components
            newComponents.year = year
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }
    var month: Int {
        get {
            components.month ?? .zero
        }
        set(month) {
            var newComponents = components
            newComponents.month = month
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }
    var day: Int {
        get {
            components.day ?? .zero
        }
        set(day) {
            var newComponents = components
            newComponents.day = day
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }
    var hour: Int {
        get {
            components.hour ?? .zero
        }
        set(hour) {
            var newComponents = components
            newComponents.hour = hour
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }
    var minute: Int {
        get {
            components.minute ?? .zero
        }
        set(minute) {
            var newComponents = components
            newComponents.minute = minute
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }
    var second: Int {
        get {
            components.second ?? .zero
        }
        set(second) {
            var newComponents = components
            newComponents.second = second
            self = Calendar.brazilian.date(from: newComponents) ?? self
        }
    }

    // MARK: Dynamic Variables
    var weekday: Int {
        Int(formatted(Date.FormatStyle().weekday(.oneDigit))) ?? .zero
    }
    
    var withoutHour: Date {
        Calendar.brazilian.date(
            from: Calendar.brazilian.dateComponents([.day, .month, .year], from: self)
        ) ?? .distantPast
    }
    
    var onlyMonthYear: Date {
        Calendar.brazilian.date(
            from: Calendar.brazilian.dateComponents([.month, .year], from: self)
        ) ?? .distantPast
    }
    
    var currentWeek: [Date] {
        var currentWeek: [Date] = []
        let week = Calendar.brazilian.dateInterval(of: .weekOfMonth, for: self)
        
        guard let firstWeekDay = week?.start else { return [] }
        
        (0..<7).forEach { day in
            if let weekday = Calendar.brazilian.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
        
        return currentWeek
    }
    
    var numberOfDaysInMonth: Int {
        guard let days = Calendar.brazilian.range(of: .day, in: .month, for: self) else {
            return .zero
        }
        return days.count
    }

    
    // MARK: Methods
    /// Converts the date to any string formats
    func format(as format: String, style: DateFormatter.Style = .long) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.dateFormat = format
        formatter.locale = .autoupdatingCurrent
        return formatter.string(from: self)
    }
    
    func isMonthEqual(_ other: Date) -> Bool {
        return self.month == other.month && self.year == other.year
    }
    
    func isMonthAfter(_ other: Date) -> Bool {
        return self.year > other.year
        || (self.month > other.month && self.year == other.year)
    }
    
    func isDayEqual(_ other: Date) -> Bool {
        return Calendar.brazilian.isDate(self, inSameDayAs: other)
    }
    
    func isTimeEqual(hour: Int, minute: Int) -> Bool {
        return self.hour == hour && self.minute == minute
    }
    
    func getCurrentMonthDate()-> [Date] {
        
        let calendar = Calendar.current
        
        guard let startingDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self)) else {
            print("Error extracting starting date")
            return .init()
        }
        guard let range = calendar.range(of: .day, in: .month, for: startingDate) else {
            print("Error extracting range")
            return .init()
        }
        
        return range.compactMap { day -> Date in
            
            guard let returnedDate = calendar.date(byAdding: .day, value: day - 1, to: startingDate) else  {
                print("Error returning date array")
                return .now
            }
            return returnedDate
        }
    }
    
    func getAnteMeridiem() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeStyle = .short
        let am =  formatter.amSymbol ?? ""
        let pm = formatter.pmSymbol ?? ""
        formatter.dateFormat = "hh a"

        let timeString = "\(formatter.string(from: self)) "

        // Check if the formatted time contains AM/PM
        if timeString.contains(am) {
            return am
        }
        if timeString.contains(pm) {
            return pm
        }
        else { return ""}
    }

    // Convenience methods for dates.
        var sevenDaysOut: Date {
            Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
        }

        var thirtyDaysOut: Date {
            Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
        }

}

public extension Calendar {
    
    // TODO: Implement internationalization (remove it and change everything back to Calendar.brazilian)
    static var brazilian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "pt_BR")
        return calendar
    }
}

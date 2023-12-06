//
//  ExtensionDate.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import Foundation

extension Date {
    
    func fetchWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        let intervalWeek = calendar.dateInterval(of: .weekOfMonth, for: startOfDay)
        guard let startOfWeek = intervalWeek?.start else {
            print("error trying to get the start of week")
            return []
        }
        var week = [WeekDay]()
        (0..<7).forEach { index in
            if let day = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(WeekDay(date: day))
            }
        }
        return week
    }
    
    func calculatePreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        guard let previousDay = calendar.date(byAdding: .day, value: -1, to: self) else {
            print("error calculating previous week")
            return []
        }
//        print(previousDay.formatDate(template: "EEEE d"))
        let startOfPreviousDay = calendar.startOfDay(for: previousDay)
        let intervalPreviousWeek = calendar.dateInterval(of: .weekOfMonth, for: startOfPreviousDay)
        var previousWeek: [WeekDay] = []
        if let startDayOfPreviousWeek = intervalPreviousWeek?.start {
            (0..<7).forEach { index in
                if let day = calendar.date(byAdding: .day, value: index, to: startDayOfPreviousWeek){
                    previousWeek.append(WeekDay(date: day))
                }
            }
        }
        return previousWeek
    }
    
    func calculateNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: self) else {
            print("error calculating the next week")
            return []
        }
        let startOfNextDay = calendar.startOfDay(for: nextDay)
        let intervalNextWeek = calendar.dateInterval(of: .weekOfMonth, for: startOfNextDay)
        var nextWeek: [WeekDay] = []
        if let startDayOfNextWeek = intervalNextWeek?.start {
            (0..<7).forEach { index in
                if let day = calendar.date(byAdding: .day, value: index, to: startDayOfNextWeek){
                    nextWeek.append(WeekDay(date: day))
                }
            }
        }
        return nextWeek
    }
    
    func isTheSameDay (to day: Date) -> Bool {
        let calendar = Calendar.current
        let isTheSame = calendar.compare(self, to: day, toGranularity: .day)
        switch isTheSame {
        case .orderedAscending:
            return false
        case .orderedDescending:
            return false
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func formatDate(template dateFormatTemplate: String) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = dateFormatTemplate
        return dateFormatter.string(from: self)
    }
    
    func calculateTime(to date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour,.minute], from: self, to: date)
        return "\(components.hour!) hours - \(components.minute!) min"
    }

}

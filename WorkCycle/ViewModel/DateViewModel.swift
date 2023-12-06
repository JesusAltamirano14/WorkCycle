//
//  DateViewModel.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import Foundation

@Observable
class DateViewModel {
    var currentDate: Date = .init()
    var weekSlider: [[WeekDay]] = []
    var weekSliderIndex: Int = 1
    var counter: Int = 1
    var createWeek: Bool = false
    
    func fillWeekSlider () -> Void {
        if self.weekSlider.isEmpty {
            let week = Date.now.fetchWeek()
            if let previousWeek = week.first?.date.calculatePreviousWeek(){
                weekSlider.append(previousWeek)
            }
            weekSlider.append(week)
            if let nextWeek = week.last?.date.calculateNextWeek(){
                weekSlider.append(nextWeek)
            }
        }
    }
    
    func changePagination() -> Void {
        if weekSliderIndex == 2 {
            if let newWeek = weekSlider[2].last?.date.calculateNextWeek() {
                weekSlider.append(newWeek)
                weekSlider.removeFirst()
                print("generated \(counter)")
                weekSliderIndex = weekSlider.count - 2
                counter += 1
                createWeek = false
            }
        }else if weekSliderIndex == 0 {
            if let previousNewWeek = weekSlider[0].first?.date.calculatePreviousWeek() {
                weekSlider.insert(previousNewWeek, at: 0)
                weekSlider.removeLast()
                weekSliderIndex = 1
                print("generated previous \(counter)")
                counter -= 1
                createWeek = false
            }
        }
    }
}

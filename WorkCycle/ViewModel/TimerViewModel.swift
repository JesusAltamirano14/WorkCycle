//
//  TimerViewModel.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 7/12/23.
//

import Foundation
import SwiftUI

@Observable
class TimerViewModel {
    var timer: Timer?
    var elapsedTime: Int = 0
    var remainingTime: Int = 0
    var timeStart: Date?
    var secondsFinal: Int
    var progressRing: CGFloat = 0
    
    init(){
        self.secondsFinal = AppStorage(wrappedValue: 0, "totalSecondsPicker").wrappedValue
        loadSavedDateToStartTimer()
    }
    
    func loadSavedDateToStartTimer() -> Void {
        if let savedTimeStart = UserDefaults.standard.object(forKey: "timeStart") as? Date {
            //Make the first Calculates
            self.timeStart = savedTimeStart
            self.elapsedTime = Int(Date().timeIntervalSince(savedTimeStart).rounded())
            self.remainingTime = Int(savedTimeStart.addingTimeInterval(TimeInterval(secondsFinal)).timeIntervalSince(Date()).rounded())
            self.progressRing = CGFloat(self.elapsedTime) / CGFloat(self.secondsFinal)
            //Then start the counting
            if timer == nil {
                startTimer()

            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func startTimer() {
        guard let date = timeStart?.addingTimeInterval(TimeInterval(secondsFinal)) else{
            return
        }
        
        //Make the calcutes for every change in the time
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime = Int(Date().timeIntervalSince(self.timeStart ?? Date()).rounded())
            self.remainingTime = Int(date.timeIntervalSince(Date()).rounded())
            self.progressRing = CGFloat(self.elapsedTime) / CGFloat(self.secondsFinal)
        }
    }
    
}

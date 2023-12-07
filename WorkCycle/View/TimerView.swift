//
//  TimerView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 7/12/23.
//

import SwiftUI

struct TimerView: View {
    
    @State private var timerVM = TimerViewModel()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    @State private var color: Color = .blue
    
    private var totalSeconds: Int {
        return (hours * 3600 + minutes * 60 + seconds)
    }
    
    @AppStorage("totalSecondsPicker") private var totalSecondsPicker: Int = 0

    var body: some View {
        VStack {
            Text("Jesus Altamirano")
            Text(String(describing: timerVM.timeStart))
            Text(String(timerVM.elapsedTime))
            Text("secondsFinal: \(timerVM.secondsFinal)")
            Text("ProgressRing: \(timerVM.progressRing)")
            Text("Reamining Time: \(timerVM.remainingTime)")
            Text("totalSeconds: \(totalSeconds)")
            ColorPicker("Color", selection: $color)
            
                if timerVM.timeStart != nil {
                        RingView()
                }else{
                        TimePickerView()
                }
            
            //MARK: BUTTONS START AND STOP
            
            if timerVM.timeStart == nil {
                Button("Start"){
                    //MARK: START THE TIMER
                    //Introduce the current Date to the UserDefaults and to the state
                    let newDate = Date()
                    UserDefaults.standard.set(newDate, forKey: "timeStart")
                    
                    //Make Animation for View changes
                    withAnimation {
                        timerVM.timeStart = newDate
                    }
                    //Initialize the timer
                    if timerVM.timer == nil {
                        timerVM.startTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(totalSeconds<=0)
            }else{
                Button("Stop"){
                    //MARK: Stop the timer when the button Stop was pressed
                    timerVM.stopTimer()
                    //Removing the date saved in the UserDefaults
                    UserDefaults.standard.removeObject(forKey: "timeStart")
                    withAnimation {
                        timerVM.timeStart = nil
                    }
                    //Reset the times
                    timerVM.elapsedTime = 0
                    timerVM.remainingTime = 0
                    timerVM.progressRing = 0
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }

        }
        .onAppear {
                    NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                        timerVM.stopTimer()
                    }

                    NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                        timerVM.loadSavedDateToStartTimer()
                    }
                }
        .onDisappear {
                   NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
                   NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
               }
        .onChange(of: totalSeconds) { oldValue, newValue in
            //Update the AppStorage
            totalSecondsPicker = newValue
            //Update the property secondsFinal
            timerVM.secondsFinal = newValue
            print("\(totalSecondsPicker)")
        }
    }

    @ViewBuilder
    private func RingView() -> some View{
        ZStack{
            //MARK: placeholder Ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.5)
            //MARK: progress Ring
            Circle()
                .trim(from: 0.0,to: min(timerVM.progressRing,1.0))
                .stroke(
                    AngularGradient(colors: [color,Color(.purple)], center: .center),
                    style: StrokeStyle(lineWidth: 15,lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: timerVM.progressRing)
            //MARK: Time Texts
            VStack(spacing: 20){
                VStack(spacing:5){
                    Text("Elapsed time")
                    Text(formatSeconds(timerVM.elapsedTime))
                        .font(.title)
                        .bold()
                }
                if timerVM.remainingTime >= 0{
                    
                    VStack(spacing:5){
                        Text("Remaining time")
                        Text(formatSeconds(timerVM.remainingTime))
                            .font(.title2)
                            .bold()
                    }
                }else{
                    VStack(spacing:5){
                        Text("Extra Time")
                        Text(formatSeconds(timerVM.remainingTime))
                            .font(.title2)
                            .bold()
                    }
                    .foregroundStyle(.red)
                }
            }
            
        }
        .padding()
        .frame(width: 300)
        .transition(.opacity)
    }
    
    @ViewBuilder
    private func TimePickerView() -> some View {
        VStack{
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 65)
                Text("hour")
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 65)
                
                Text("min")

                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 65)
                Text("sec")
            }
        }
        .frame(height: 300)
        .transition(.opacity)
    }
    
    func formatSeconds(_ totalSeconds: Int) -> String {
        let hours = abs(totalSeconds / 3600)
        let minutes = abs((totalSeconds % 3600) / 60)
        let seconds = abs(totalSeconds % 60)

        return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
    }
}

#Preview {
    TimerView()
}

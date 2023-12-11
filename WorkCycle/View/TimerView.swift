//
//  TimerView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 7/12/23.
//

import SwiftUI
import AlertKit

struct TimerView: View {
    
    @State private var timerVM = TimerViewModel()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var disableButton: Bool = true
    @State private var showAlertToSave: Bool = false
    @State private var showAlertRing: Bool = false
    
    @State private var workItem: TaskItem = TaskItem()
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("totalSecondsPicker") private var totalSecondsPicker: Int = 0
    @AppStorage("colorRing1") private var colorRing1: String = "#0096FF"
    @AppStorage("colorRing2") private var colorRing2: String = "#9437FF"
    
    @EnvironmentObject private var workVM: WorkViewModel
    
    private var totalSeconds: Int {
        return (hours * 3600 + minutes * 60 + seconds)
    }
    
    let alertToSave = AlertAppleMusic17View(title: "Added to calendar", subtitle: nil, icon: .done)
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading){
//                Text("Jesus Altamirano")
//                Text(String(describing: timerVM.timeStart))
//                Text(String(timerVM.elapsedTime))
//                Text("secondsFinal: \(timerVM.secondsFinal)")
//                Text("ProgressRing: \(timerVM.progressRing)")
//                Text("Reamining Time: \(timerVM.remainingTime)")
//                Text("totalSeconds: \(totalSeconds)")
//                ColorPicker("Color", selection: $color)
                
                ColorPickerWork(typeOfWork: $workItem.typeOfWork, withPrice: true)
                
                HStack{
                    if timerVM.timeStart != nil {
                            RingView()
                    }else{
                            TimePickerView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                //MARK: BUTTONS START AND STOP
                
                HStack{
                    if timerVM.timeStart == nil {
                        Button("Start"){
                            //MARK: START THE TIMER
                            //Introduce the current Date to the UserDefaults and to the state
                            let newDate = Date()
                            workItem.entryHour = newDate
                            UserDefaults.standard.set(newDate, forKey: "timeStart")
                            
                            //Make Animation for View changes
                            withAnimation {
                                timerVM.timeStart = newDate
                            }
                            //Initialize the timer
                            if timerVM.timer == nil {
                                timerVM.startTimer()
                            }
                            //Vibration
                            HapticManager.instance.notificationVibrate(type: .success)
                        }
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(disableButton ? .gray.opacity(0.7) : .green)
                        )
                        .foregroundStyle(.white)
                        .disabled(totalSeconds<=0)
                        .alert(isPresent: $showAlertToSave, view: alertToSave)
                    }else{
                        Button(action: {
                            //MARK: Stop the timer when the button Stop was pressed
                            
                            let calendar = Calendar.current
                            
                            //Remove seconds to entry Hour
                            let newEntryHourComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: workItem.entryHour)
                            let newEntryHourWithoutSeconds = calendar.date(from: newEntryHourComponents) ?? workItem.entryHour
                            workItem.entryHour = newEntryHourWithoutSeconds
                            
                            let newDateExit = Date()
                            //Remove seconds to exit Hour
                            let newExitHourComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: newDateExit)
                            let newExitHourWithoutSeconds = calendar.date(from: newExitHourComponents) ?? newDateExit
                            workItem.exitHour = newExitHourWithoutSeconds
                            
                            modelContext.insert(workItem)
                            
                            timerVM.stopTimer()
                            //Removing the entryHourDate saved in the UserDefaults
                            UserDefaults.standard.removeObject(forKey: "timeStart")
                            withAnimation {
                                timerVM.timeStart = nil
                            }
                            //Reset the times
                            timerVM.elapsedTime = 0
                            timerVM.remainingTime = 0
                            timerVM.progressRing = 0
                            
                            //New instance is created in order to permit save other TaskItem and mantain the previous TypeOfWork
                            workItem = TaskItem(typeOfWork: workItem.typeOfWork)
                            HapticManager.instance.notificationVibrate(type: .success)
                            showAlertToSave = true
                        }, label: {
                            Text("SAVE")
                                .foregroundStyle(.white)
                        })
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(.blue)
                        )
                        Button(action: {
                            showAlertRing = true
                        }, label: {
                            Text("CANCEL")
                                .foregroundStyle(.white)
                        })
                        .alert("Are you sure you want to stop the timer?", isPresented: $showAlertRing, actions: {
                            Button("Stop timer", role: .destructive) {
                                //MARK: Stop the timer when the button Stop is pressed
                                
                                timerVM.stopTimer()
                                
                                //Removing the entryHourDate saved in the UserDefaults
                                UserDefaults.standard.removeObject(forKey: "timeStart")
                                withAnimation {
                                    timerVM.timeStart = nil
                                }
                                
                                //Reset the times
                                timerVM.elapsedTime = 0
                                timerVM.remainingTime = 0
                                timerVM.progressRing = 0

                                //Vibration
                                HapticManager.instance.notificationVibrate(type: .error)
                            }
                        })
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(.red)
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.top)
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(Date().formatDate(template: "dd MMMM"))

        }
        .onAppear {
            if totalSeconds <= 0 {
                disableButton = true
            }
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
            if totalSeconds <= 0 {
                disableButton =  true
            }else {
                disableButton = false
            }
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
                    AngularGradient(colors: [Color(hex: colorRing1),Color(hex:colorRing2)], center: .center),
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
        .environmentObject(WorkViewModel())
        .modelContainer(for: TaskItem.self)
}

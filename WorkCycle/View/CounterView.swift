//
//  CounterView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var taskItems: [TaskItem]
    @FocusState private var isInputActive: Bool
    @EnvironmentObject private var workVM: WorkViewModel
    @State private var showAlert: Bool = false
    
    init() {
        let predicate = #Predicate<TaskItem> {
            $0.phaseId == 2
        }
        let sortDescriptor = [SortDescriptor(\TaskItem.entryHour, order: .forward)]
        
        self._taskItems = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    
    var body: some View {
        NavigationStack{
            if !taskItems.isEmpty {
                List {
                    Section(header: Text("Jobs to be counted")){
                        ForEach(taskItems) { task in
                            HStack(spacing: 6){
                                VStack(alignment:.leading){
                                    Text(workVM.getName(type: task.typeOfWork))
                                            .fontWeight(.bold)
                                    Text(task.entryHour.formatDate(template: "MMMM dd"))
                                    Text("\(task.entryHour.formatDate(template: "hh:mm a")) - \(task.exitHour.formatDate(template: "hh:mm a"))")
                                }
                                Spacer()
                                VStack(alignment:.trailing){
                                    Text("\(String(format: "%.2f$ / HOUR", workVM.getPrice(type: task.typeOfWork)))")
                                        .foregroundStyle(.secondary)
                                    HStack{
                                        Image(systemName: "timer")
                                        Text(task.entryHour.calculateTime(to: task.exitHour))
                                    }
                                    Text(String(format:"%.2f $",workVM.calculateMount(taskItems: [task])))
                                        .fontWeight(.bold)
                                }
                                .fontWeight(.semibold)
                            }
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(hex:workVM.getColor(type: task.typeOfWork)))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                let taskFounded = taskItems[index]
                                taskFounded.phase = .phase1
                                taskFounded.phaseId = 1
                            }
                        })
                    }
                }
                
                //MARK: SECTION INFORMATION
                VStack(alignment:.leading, spacing:2){
                    Text("Information")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    HStack{
                        Text(sumHoursAndMinutes(records:taskItems))
                        Spacer()
                    }
                    //Mount
                    Text(String(format:"%.2f $",workVM.calculateMount(taskItems: taskItems)))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Button {
                        showAlert =  true
                    } label: {
                        Text("SAVE")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .frame(width: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .alert("Are you sure you want to save this data?", isPresented: $showAlert) {
                        Button("Save data", role: .destructive) {
                            if !taskItems.isEmpty {
                                for task in taskItems {
                                    task.phase = .phase3
                                    task.phaseId = 3
                                }
                            }
                            //Vibration
                            HapticManager.instance.notificationVibrate(type: .success)
                        }
                    }
                }
                .padding()
                .navigationTitle("Calculate")
            }
        }
        .overlay {
            if taskItems.isEmpty {
                HStack(alignment:.center, spacing: 20){
                    Image(systemName: "tray.and.arrow.down")
                        .resizable()
                        .frame(width: 38, height: 35)
                    VStack(alignment:.leading){
                        Text("This section is empty")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("Add jobs in calendar to appear here")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

            }
        }

    }
    
    func sumHoursAndMinutes(records: [TaskItem]) -> String {
        let calendar = Calendar.current
        var totalHours = 0
        var totalMinutes = 0

        for record in records {
            let components = calendar.dateComponents([.hour, .minute], from: record.entryHour, to: record.exitHour)
            totalHours += components.hour ?? 0
            totalMinutes += components.minute ?? 0
        }

        // Add overflow minutes to hours
        totalHours += totalMinutes / 60
        totalMinutes = totalMinutes % 60
        
        return "Total time: \(totalHours) hours - \(totalMinutes) min"
    }
}

#Preview {
    CounterView()
        .modelContainer(for: TaskItem.self)
        .environmentObject(WorkViewModel())
}

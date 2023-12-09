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
                    Section(header: Text("Works to be counted")){
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
                VStack(alignment:.leading, spacing:2){
                    Text("Information")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    HStack{
                        Text(sumHoursAndMinutes(records:taskItems))
                        Spacer()
                    }
                    Text(String(format:"%.2f $",workVM.calculateMount(taskItems: taskItems)))
                    Button {
                        if !taskItems.isEmpty {
                            for task in taskItems {
                                task.phase = .phase3
                                task.phaseId = 3
                            }
                        }
                    } label: {
                        Text("Save")
                            .frame(width: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding()
                .navigationTitle("Calculate")
                //Adding the button Done
                .toolbar{
                    ToolbarItemGroup(placement:.keyboard){
                        Spacer()
                        Button {
                            isInputActive = false
                        } label: {
                            Text("Done")
                        }
                    }
                }
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

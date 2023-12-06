//
//  TaskView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI
import SwiftData

struct TaskView: View {
    
    @Environment(\.modelContext) private var modelContext
    var currentDate: Date
    
    @Query private var taskItems: [TaskItem]
    
    @State private var selectedItems: Set<String> = []
    
    init(currentDate: Date) {
        self.currentDate = currentDate
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicateTask = #Predicate<TaskItem> {
            $0.entryHour >= startOfDay && $0.entryHour < endOfDay
        }
        
        let sortDescriptor = [SortDescriptor(\TaskItem.entryHour, order: .forward)]
        
        self._taskItems = Query(filter: predicateTask, sort: sortDescriptor, animation: .snappy)
        
        self._selectedItems = State(initialValue: selectedItems)
    }
    
    var body: some View {
            VStack{
                List{
                    ForEach(taskItems) { task in
                        NavigationLink(value: task) {
                            HStack(spacing: 10){
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.black)
                                    .background {
                                        Circle()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(Color(task.typeOfWork.rawValue))
                                    }
                                VStack(alignment:.leading, spacing: 6){
                                    HStack{
                                        Text(task.typeOfWork.descr)
                                            .strikethrough(task.phase == .phase3 ? true : false, color: .black)
                                            .fontWeight(.bold)
                                        Spacer()
                                        if task.phase == .phase1 {
                                            Text("Ready to be counted")
                                                .fontWeight(.semibold)
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                        if task.phase == .phase2 {
                                            Text("Added to be counted")
                                                .font(.footnote)
                                                .foregroundStyle(.purple)
                                        }
                                        if task.phase == .phase3 {
                                            Text("already counted")
                                                .font(.footnote)
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    Text(task.entryHour.formatDate(template: "MMMM dd"))
                                    Text("\(task.entryHour.formatDate(template: "hh:mm a")) - \(task.exitHour.formatDate(template: "hh:mm a"))")
                                    HStack{
                                        Image(systemName: "timer")
                                        Text(task.entryHour.calculateTime(to: task.exitHour))
                                    }
                                }
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(Color(task.typeOfWork.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                task.phase = .phase2
                                task.phaseId = 2
                            } label: {
                                Label("Add", systemImage: "star")
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true){
                            Button(role: .destructive) {
                                modelContext.delete(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .disabled(task.phaseId == 3)
                    }
                    
                }
                .listStyle(.plain)
            }
            .overlay {
                if taskItems.isEmpty {
                    HStack(alignment:.center, spacing: 20){
                        Image(systemName: "tray.and.arrow.down")
                            .resizable()
                            .frame(width: 38, height: 35)
                        Text("No work founded")
                            .font(.callout)
                    }
    
                }
            }
    }
    
}

#Preview {
    TaskView(currentDate: Date.now)
        .modelContainer(for: TaskItem.self)
}

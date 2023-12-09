//
//  EditWorkView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI

struct EditWorkView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
//    var taskItem: TaskItem
//    @State var selectedEntryHour: Date
//    @State var selectedExitHour: Date
//    @State private var selectedType: TypeOfWork
//    
//    init(taskItem: TaskItem) {
//        self.taskItem = taskItem
//        self._selectedEntryHour = State(initialValue: taskItem.entryHour)
//        self._selectedExitHour = State(initialValue: taskItem.exitHour)
//        self._selectedType = State(initialValue: taskItem.typeOfWork)
//    }
    
    @Bindable var workItem: TaskItem
    
    var body: some View {
        Form {
            //MARK: TITTLE
            
            Text(Calendar.current.startOfDay(for: workItem.entryHour).formatDate(template: "MMMM dd"))
                .font(.title)
            
            //MARK: COLORS - COMPONENTS
            
            ColorPickerWork(typeOfWork: $workItem.typeOfWork, withPrice: false)
            
            DatePicker("entry", selection: $workItem.entryHour, displayedComponents: .hourAndMinute)
            DatePicker("exit", selection: $workItem.exitHour,in: workItem.entryHour... ,displayedComponents: .hourAndMinute)
            //MARK: BUTTON TO SAVE WORKS
            Button(action: {
                dismiss()
            }, label: {
                Text("Edit")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 20)
                    .padding()
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex:workItem.typeOfWork.rawValue))
                    )
            })
            .padding(.top, 22)
        }
    }
}

#Preview {
    EditWorkView(workItem: TaskItem(id: "jesus", entryHour: Date(), exitHour: Date(), typeOfWork: .work1, phase: .phase1))
        .environmentObject(WorkViewModel())
}

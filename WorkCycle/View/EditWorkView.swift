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
            
            //MARK: COLORS
            
            VStack(alignment: .leading){
                Text(workItem.typeOfWork.descr)
                    .foregroundStyle(.secondary)
                HStack{
                    ForEach(TypeOfWork.allCases, id: \.self) { type in
                        ZStack{
                            if type ==  workItem.typeOfWork{
                                Circle()
                                    .frame(width: 52, height: 52)
                            }
//
                            Color(type.rawValue)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    workItem.typeOfWork = type
                                }
                        }
                    }
                }
            }
            DatePicker("entry", selection: $workItem.entryHour, displayedComponents: .hourAndMinute)
            DatePicker("exit", selection: $workItem.exitHour,in: workItem.entryHour... ,displayedComponents: .hourAndMinute)
            //MARK: BUTTON TO SAVE WORKS
            Button(action: {
//                let newTaskItem = TaskItem(id: taskItem.id, entryHour: selectedEntryHour, exitHour: selectedExitHour, typeOfWork: selectedType)
//                modelContext.insert(newTaskItem)
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
                            .fill(Color(workItem.typeOfWork.rawValue))
                    )
            })
            .padding(.top, 22)
        }
    }
}

//#Preview {
//    EditWorkView()
//}

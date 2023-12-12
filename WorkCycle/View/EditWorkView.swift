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
    @EnvironmentObject var workVM: WorkViewModel
    
    @Bindable var workItem: TaskItem
    
    @State private var entryHourPicker: Date
    @State private var exitHourPicker: Date
    @State private var typeOfWorkPicker: TypeOfWork
    
    init(workItem: TaskItem){
        self.workItem = workItem
        self._entryHourPicker = State(initialValue: workItem.entryHour)
        self._exitHourPicker = State(initialValue: workItem.exitHour)
        self._typeOfWorkPicker = State(initialValue: workItem.typeOfWork)
    }
    
    var body: some View {
        Form {
            //MARK: TITTLE
            
            Text(Calendar.current.startOfDay(for: workItem.entryHour).formatDate(template: "MMMM dd"))
                .font(.title)
            
            //MARK: COLORS - COMPONENTS
            
            ColorPickerWork(typeOfWork: $typeOfWorkPicker, withPrice: false)
            
            DatePicker("entry", selection: $entryHourPicker, displayedComponents: .hourAndMinute)
            DatePicker("exit", selection: $exitHourPicker,in: entryHourPicker... ,displayedComponents: .hourAndMinute)
            //MARK: BUTTON TO SAVE WORKS
            Button(action: {
                workItem.entryHour = entryHourPicker
                workItem.exitHour = exitHourPicker
                workItem.typeOfWork = typeOfWorkPicker
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
                            .fill(Color(hex:workVM.getColor(type: workItem.typeOfWork)))
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

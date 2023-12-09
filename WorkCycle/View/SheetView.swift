//
//  SheetView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//
import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var workVM: WorkViewModel
    
    var currentDateSelected: Date
    
    //Init a workItem Data
    @State private var workItem: TaskItem
    
    
    init(currentDateSelected: Date) {
        
        //Pick the currentDate selected by the Sheet and use the hours and minutes instantanious
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year,.month,.day], from: currentDateSelected)
        let components2 = calendar.dateComponents([.hour,.minute], from: Date())
        var combinedComponents = DateComponents()
        combinedComponents.year = components1.year
        combinedComponents.month = components1.month
        combinedComponents.day = components1.day
        combinedComponents.hour = components2.hour
        combinedComponents.minute = components2.minute
        
        self.currentDateSelected = calendar.date(from: combinedComponents) ?? currentDateSelected
        self._workItem = State(initialValue: TaskItem(entryHour: self.currentDateSelected, exitHour: self.currentDateSelected))
    }
    
    private var startOfDay: Date {
        return Calendar.current.startOfDay(for: currentDateSelected)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing:10){
            
            //MARK: Button X
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 15, height: 15)
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            //MARK: TITTLE
            
            Text(currentDateSelected.formatDate(template: "MMMM dd"))
                .font(.title)
            
            //MARK: COLORS
            
            ColorPickerWork(typeOfWork: $workItem.typeOfWork, withPrice: false)
            
            //MARK: SELECT HOURS
            
            DatePicker("entry", selection: $workItem.entryHour, in: startOfDay..., displayedComponents: .hourAndMinute)
            DatePicker("exit", selection: $workItem.exitHour, in: workItem.entryHour..., displayedComponents: .hourAndMinute)
            
            //MARK: BUTTON TO SAVE WORKS
            Button(action: {
                modelContext.insert(workItem)
                dismiss()
            }, label: {
                Text("Save")
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
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SheetView(currentDateSelected: Date.now)
        .modelContainer(for: TaskItem.self)
        .environmentObject(WorkViewModel())
}

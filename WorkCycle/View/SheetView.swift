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
    
    var currentDate: Date
    @State private var workItem: TaskItem
    init(currentDate: Date) {
        self.currentDate = currentDate
        self._workItem = State(initialValue: TaskItem(entryHour: self.currentDate, exitHour: self.currentDate))
    }
    
    private var startOfDay: Date {
        return Calendar.current.startOfDay(for: currentDate)
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
            
            Text(currentDate.formatDate(template: "MMMM dd"))
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
            //MARK: SELECT HOURS
            
            DatePicker("entry", selection: $workItem.entryHour, in: startOfDay..., displayedComponents: .hourAndMinute)
            DatePicker("exit", selection: $workItem.exitHour, in: workItem.entryHour..., displayedComponents: .hourAndMinute)
            
            //MARK: BUTTON TO SAVE WORKS
            Button(action: {
//                let taskItem: TaskItem = TaskItem(entryHour: entryHour, exitHour: exitHour, typeOfWork: selectedType)
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
                            .fill(Color(workItem.typeOfWork.rawValue))
                    )
            })
            .padding(.top, 22)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    SheetView(currentDate: Date.now)
        .modelContainer(for: TaskItem.self)
}

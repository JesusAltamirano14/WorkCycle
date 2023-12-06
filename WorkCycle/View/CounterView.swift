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
    @State private var price: String = ""
    @FocusState private var isInputActive: Bool
    
    init() {
        let predicate = #Predicate<TaskItem> {
            $0.phaseId == 2
        }
        let sortDescriptor = [SortDescriptor(\TaskItem.entryHour, order: .forward)]
        
        self._taskItems = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    
    var body: some View {
        NavigationStack{
                List {
                    Section(header: Text("Works to be counted")){
                        ForEach(taskItems) { task in
                            HStack(spacing: 6){
                                VStack(alignment:.leading){
                                    Text(task.typeOfWork.descr)
                                            .fontWeight(.bold)
                                    Text(task.entryHour.formatDate(template: "MMMM dd"))
                                    Text("\(task.entryHour.formatDate(template: "hh:mm a")) - \(task.exitHour.formatDate(template: "hh:mm a"))")
                                }
                                Spacer()
                                HStack{
                                    Image(systemName: "timer")
                                    Text(task.entryHour.calculateTime(to: task.exitHour))
                                }
                                .fontWeight(.semibold)
                            }
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(task.typeOfWork.rawValue))
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
                        //Price TextField
                        TextField("Price", text: $price)
                            .textFieldStyle(.roundedBorder)
                            .focused($isInputActive)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    if let price = Float(price) {
                        Text(calculateMount(records:taskItems, price:price))
                    }
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
        .overlay {
            if taskItems.isEmpty {
                HStack(alignment:.center, spacing: 20){
                    Image(systemName: "tray.and.arrow.down")
                        .resizable()
                        .frame(width: 38, height: 35)
                    VStack(alignment:.leading){
                        Text("This section is empty")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("Add jobs to appear here")
                            .font(.callout)

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
    
    func calculateMount(records:[TaskItem], price: Float) -> String {
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
        let mount: Float = Float(totalHours)*price + (Float(totalMinutes)*price)/60
        return String(format: "Mount: %.2f$", mount)
    }
}

#Preview {
    CounterView()
        .modelContainer(for: TaskItem.self)
}


//struct CustomTextField: UIViewRepresentable {
//    @Binding var text: String
//    var keyType: UIKeyboardType
//    var placeholder: String
//
//    func makeUIView(context: Context) -> UITextField {
//        let textField = UITextField()
//        textField.keyboardType = keyType
//        textField.placeholder = placeholder
//
//        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
//
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(textField.doneButtonTapped(button:)))
//        toolBar.setItems([doneButton], animated: true)
//        toolBar.isUserInteractionEnabled = true
//        textField.inputAccessoryView = toolBar
//        return textField
//    }
//
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = text
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject {
//        var parent: CustomTextField
//
//        init(_ textField: CustomTextField) {
//            self.parent = textField
//        }
//
//        @objc func textFieldDidChange(_ textField: UITextField) {
//            parent.text = textField.text ?? ""
//        }
//    }
//}
//
//private extension UITextField {
//    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
//        self.resignFirstResponder()
//    }
//}
//
//

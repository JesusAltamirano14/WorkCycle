//
//  SheetConfigView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 7/12/23.
//

import SwiftUI

struct SheetConfigView: View {
    
    @AppStorage("colorTheme") private var colorTheme: String = "#00CC00"
    @AppStorage("colorRing1") private var colorRing1: String = "#0096FF"
    @AppStorage("colorRing2") private var colorRing2: String = "#9437FF"
    
    @State private var colorThemePicker: Color
    @State private var colorRing1Picker: Color
    @State private var colorRing2Picker: Color
    
    init(){
        self._colorThemePicker = State(initialValue: Color(hex:_colorTheme.wrappedValue))
        self._colorRing1Picker = State(initialValue: Color(hex:_colorRing1.wrappedValue))
        self._colorRing2Picker = State(initialValue: Color(hex:_colorRing2.wrappedValue))
    }

    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Colores")) {
                    ColorPicker("Theme color", selection: $colorThemePicker)
                    ColorPicker("Ring Color 1", selection: $colorRing1Picker)
                    ColorPicker("Ring Color 2", selection: $colorRing2Picker)
                }
                Section(header: Text("JOBS")) {
                    ForEach(TypeOfWork.allCases) { type in
                        NavigationLink(value: type) {
                            Text(type.descr)
                        }
                    }
                }
            }
            .navigationDestination(for: TypeOfWork.self) { type in
                ConfigViewSecond(typeOfWork: type)
            }
            .navigationTitle("Configuration")
            .onChange(of: colorThemePicker) { oldValue, newValue in
                colorTheme = newValue.toHex()
            }
            .onChange(of: colorRing1Picker) { oldValue, newValue in
                colorRing1 = newValue.toHex()
            }
            .onChange(of: colorRing2Picker) { oldValue, newValue in
                colorRing2 = newValue.toHex()
            }
        }
    }
}

struct ConfigViewSecond: View {
    
    var typeOfWork: TypeOfWork
    @EnvironmentObject var workVM: WorkViewModel
    @State private var colorPicker: Color = .clear
    @State private var nameField: String = ""
    @State private var priceSlider: Float = 0
    
    
    var body: some View {
            Form{
                HStack{
                    Text("Name: ")
                    TextField("Name of The", text:$nameField)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.gray)
                }
                ColorPicker("Color",selection: $colorPicker)
                HStack{
                    Slider(value: $priceSlider,in: 1...50, step: 0.5)
                    Text("\(String(format: "%.2f", priceSlider))")
                }
            }
            .onAppear{
                self.colorPicker = Color(hex:workVM.getColor(type: typeOfWork))
                self.nameField = workVM.getName(type: typeOfWork)
                self.priceSlider = workVM.getPrice(type: typeOfWork)
            }
            .onChange(of: colorPicker) { oldValue, newValue in
                workVM.saveColorIntoStorage(type: typeOfWork, dataToSave: newValue.toHex())
            }
            .onChange(of: nameField) { oldValue, newValue in
                workVM.saveNameIntoStorage(type: typeOfWork, nameToSave: newValue)
                HapticManager.instance.impactVibrate(style: .soft)
            }
            .onChange(of: priceSlider) { oldValue, newValue in
                workVM.savePriceIntoStorage(type: typeOfWork, priceToSave: newValue)
                HapticManager.instance.impactVibrate(style: .medium)
            }
    }
}


#Preview {
    ConfigViewSecond(typeOfWork: .work1)
        .environmentObject(WorkViewModel())
}

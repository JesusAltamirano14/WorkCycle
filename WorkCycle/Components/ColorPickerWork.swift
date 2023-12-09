//
//  ColorPickerWork.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 8/12/23.
//

import SwiftUI

struct ColorPickerWork: View {
    
    @EnvironmentObject var workVM: WorkViewModel
    @Binding var typeOfWork: TypeOfWork
    var withPrice: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text(workVM.getName(type: typeOfWork))
                .foregroundStyle(.secondary)
            HStack{
                ForEach(TypeOfWork.allCases, id: \.self) { type in
                    ZStack{
                        if type == typeOfWork{
                            Circle()
                                .frame(width: 53, height: 53)
                        }
                        Color(hex:workVM.getColor(type: type))
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                typeOfWork = type
                            }
                    }
                }
            }
            if withPrice == true {
                Text(String(format: "%.2f $", workVM.getPrice(type: typeOfWork)))
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    ColorPickerWork(typeOfWork: .constant(.work1), withPrice: true)
        .environmentObject(WorkViewModel())
}

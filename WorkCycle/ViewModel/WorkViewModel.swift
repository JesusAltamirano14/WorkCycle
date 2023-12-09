//
//  WorkViewModel.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 7/12/23.
//

import Foundation


class WorkViewModel: ObservableObject {
    @Published var colorWork1: String = UserDefaults.standard.string(forKey: TypeOfWork.work1.descr) ?? TypeOfWork.work1.rawValue
    @Published var colorWork2: String = UserDefaults.standard.string(forKey: TypeOfWork.work2.descr) ?? TypeOfWork.work2.rawValue
    @Published var colorWork3: String = UserDefaults.standard.string(forKey: TypeOfWork.work3.descr) ?? TypeOfWork.work3.rawValue
    
    @Published var priceWork1: Float = UserDefaults.standard.float(forKey: "price\(TypeOfWork.work1.descr)")
    @Published var priceWork2: Float = UserDefaults.standard.float(forKey: "price\(TypeOfWork.work2.descr)")
    @Published var priceWork3: Float = UserDefaults.standard.float(forKey: "price\(TypeOfWork.work3.descr)")
    
    @Published var nameWork1: String = UserDefaults.standard.string(forKey: "name\(TypeOfWork.work1.descr)") ?? TypeOfWork.work1.descr
    @Published var nameWork2: String = UserDefaults.standard.string(forKey: "name\(TypeOfWork.work2.descr)") ?? TypeOfWork.work2.descr
    @Published var nameWork3: String = UserDefaults.standard.string(forKey: "name\(TypeOfWork.work3.descr)") ?? TypeOfWork.work3.descr
    
    

    
    func saveColorIntoStorage(type:TypeOfWork, dataToSave data: String) -> Void {
        UserDefaults.standard.set(data, forKey: type.descr)
        updateColor(type: type, data: data)
    }
    
    func savePriceIntoStorage(type:TypeOfWork, priceToSave price: Float) -> Void {
        UserDefaults.standard.set(price, forKey: "price\(type.descr)")
        updatePrice(type: type, price: price)
    }
    
    func saveNameIntoStorage(type:TypeOfWork, nameToSave name: String) -> Void {
        UserDefaults.standard.set(name, forKey: "name\(type.descr)")
        updateName(type: type, name: name)
    }
    
    func updateColor(type:TypeOfWork, data: String) -> Void {
        switch type {
        case .work1:
            self.colorWork1 = data
        case .work2:
            self.colorWork2 = data
        case .work3:
            self.colorWork3 = data
        }
    }
    
    func updatePrice(type:TypeOfWork, price: Float) -> Void {
        switch type {
        case .work1:
            self.priceWork1 = price
        case .work2:
            self.priceWork2 = price
        case .work3:
            self.priceWork3 = price
        }
    }
    
    func updateName(type: TypeOfWork, name: String) -> Void {
        switch type {
        case .work1:
            self.nameWork1 = name
        case .work2:
            self.nameWork2 = name
        case .work3:
            self.nameWork3 = name
        }
    }
    
    func getColor(type: TypeOfWork) -> String{
        switch type {
        case .work1:
            return self.colorWork1
        case .work2:
            return self.colorWork2
        case .work3:
            return self.colorWork3
        }
    }
    
    func getPrice(type: TypeOfWork) -> Float{
        switch type {
        case .work1:
            self.priceWork1
        case .work2:
            self.priceWork2
        case .work3:
            self.priceWork3
        }
    }
    
    func getName(type: TypeOfWork) -> String {
        switch type {
        case .work1:
            return self.nameWork1
        case .work2:
            return self.nameWork2
        case .work3:
            return self.nameWork3
        }
    }
    
    func calculateMount(taskItems:[TaskItem]) -> Float {
        let calendar = Calendar.current
        var mount: Float = 0

        for taskItem in taskItems {
            let components = calendar.dateComponents([.hour,.minute], from: taskItem.entryHour, to: taskItem.exitHour)
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            let price = self.getPrice(type: taskItem.typeOfWork)
            mount += (price * Float(hours) + (price * Float(minutes))/60 )
        }
        // Add overflow minutes to hours
        return mount
    }
}

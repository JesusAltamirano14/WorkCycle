//
//  TaskItem.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import Foundation
import SwiftData


@Model
final class TaskItem{
    @Attribute(.unique) var id: String
    var entryHour: Date
    var exitHour: Date
    var typeOfWork: TypeOfWork = TypeOfWork.work1
    var phase: Phase = Phase.phase1
    var phaseId: Phase.ID
    
    init(
        id:String = UUID().uuidString,
        entryHour: Date = Date.now,
        exitHour: Date = Date.now,
        typeOfWork: TypeOfWork = TypeOfWork.work1,
        phase: Phase = Phase.phase1
    ) {
        self.id = id
        self.entryHour = entryHour
        self.exitHour = exitHour
        self.typeOfWork = typeOfWork
        self.phase = phase
        self.phaseId = phase.id
    }
}

enum TypeOfWork: String, CaseIterable, Codable, Identifiable {
    case work1 = "#C4FF97"
    case work2 = "#ABCCFF"
    case work3 = "#FDFFA8"
    
    var id: String {
        rawValue
    }
}
extension TypeOfWork {
    var descr: String {
        switch self {
        case .work1:
            return "Work 1"
        case .work2:
            return "Work 2"
        case .work3:
            return "Work 3"
        }
    }
}

enum Phase: Int, CaseIterable, Codable, Identifiable {
    case phase1 = 1
    case phase2
    case phase3
    
    var id: Int {
        rawValue
    }
}

extension Phase {
    var descr: String {
        switch self {
        case .phase1:
            return "phase 1"
        case .phase2:
            return "phase 2"
        case .phase3:
            return "phase 3"
        }
    }
}


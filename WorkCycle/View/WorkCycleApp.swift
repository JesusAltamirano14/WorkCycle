//
//  WorkCycleApp.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI
import SwiftData

@main
struct WorkCycleApp: App {
    
    @StateObject var workVM: WorkViewModel = WorkViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        
        WindowGroup {
            HomeView()
                .environmentObject(workVM)
        }
        .modelContainer(sharedModelContainer)
    }
    
    
}

//
//  HomeView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("colorTheme") private var colorHex: String = "00CC00"
    
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            DateView()
                .tabItem {
                    Text("Calendar")
                    Image(systemName: "calendar")
                }
            CounterView()
                .tabItem {
                    Text("Calculate")
                    Image(systemName: "number")
                }
        }
        .accentColor(Color(hex: colorHex))
    }
}

#Preview {
    HomeView()
        .modelContainer(for: TaskItem.self)
}

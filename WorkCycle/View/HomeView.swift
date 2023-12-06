//
//  HomeView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            DateView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
            CounterView()
                .tabItem {
                    Text("Calculate")
                    Image(systemName: "number")
                }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: TaskItem.self)
}

//
//  PlankTimerApp.swift
//  PlankTimer
//
//  Created by Jayce Sagvold on 7/4/23.
//

import SwiftUI

@main
struct OneHabitApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .badge(2)
                    .tabItem {
                        Label("Exercise", systemImage: "timer")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "archivebox.fill")
                    }
                
                GuidanceView()
                    .tabItem {
                        Label("Guidance", systemImage: "questionmark.folder.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

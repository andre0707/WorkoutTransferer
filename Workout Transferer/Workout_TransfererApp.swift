//
//  Workout_TransfererApp.swift
//  Workout Transferer
//
//  Created by Andre Albach on 11.02.22.
//

import SwiftUI

@main
struct Workout_TransfererApp: App {
    
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(workoutManager)
            
                .onOpenURL { url in
                    
                    guard url.isFileURL, url.pathExtension == "wotrfi" else {
                        print("Tried to open: \(url.path)")
                        return
                    }
                    
                    workoutManager.handle(url)
                }
        }
    }
}

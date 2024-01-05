//
//  Workout_TransfererApp.swift
//  Workout Transferer
//
//  Created by Andre Albach on 11.02.22.
//

import os
import SwiftUI

/// A logger to log errors
fileprivate let logger = Logger(subsystem: Bundle.main.bundleIdentifier, category: "Workout_TransfererApp")


@main
struct Workout_TransfererApp: App {
    
    /// Reference to the workout manager object
    @StateObject private var workoutManager = WorkoutManager()
    
    /// The body
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(workoutManager)
            
                .onOpenURL { url in
                    
                    guard url.isFileURL, url.pathExtension == "wotrfi" else {
                        logger.log("Tried to open: \(url.path, privacy: .public)")
                        return
                    }
                    
                    workoutManager.handle(url)
                }
        }
    }
}

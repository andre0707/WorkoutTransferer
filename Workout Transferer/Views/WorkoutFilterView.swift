//
//  WorkoutFilterView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import SwiftUI

/// The main interaction view.
/// It lits the filter and export options
struct WorkoutFilterView: View {
    
    /// Reference to the workout manager
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    
    /// The body of the view
    var body: some View {
        Form {
            Section(content: {
                DatePicker("Start date",
                           selection: $workoutManager.startDate,
                           in: Date.distantPast ... Date.now,
                           displayedComponents: [.date])
                
                DatePicker("End date",
                           selection: $workoutManager.endDate,
                           in: Date.distantPast ... Date.now,
                           displayedComponents: [.date])
            }, header: {
                Text("Date Filter")
                    .font(.headline)
            }, footer: {
                Text("Only workouts during these days will be read")
            })
            
            Section(content: {
                Toggle("Include calories", isOn: $workoutManager.includeCaloriesInExport)
            }, header: {
                Text("Export Options")
                    .font(.headline)
            }, footer: {
                Text("These options will be applied when exporting/sharing workouts")
            })
            
            Section(content: {
                NavigationLink("Read workouts", isActive: $workoutManager.isWorkoutListVisible, destination: {
                    WorkoutListView()
                })
            }, header: {
                Text("Export")
                    .font(.headline)
            }, footer: {
                Text("This will read all the workouts matching the set filter. You will then see a list of all the matching workouts to select the ones you want to export.")
            })
            
            Section(content: {
                Text("Just open any *.wotrfi* file with this app the start the import process.")
                    .fixedSize(horizontal: false, vertical: true)
            }, header: {
                Text("Import")
                    .font(.headline)
            })
        }
        .navigationTitle("Workout Filter")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutFilterView()
                .environmentObject(WorkoutManager.preview)
        }
    }
}

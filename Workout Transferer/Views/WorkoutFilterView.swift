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
        NavigationStack{
            Form {
                Section(content: {
                    MultiPicker(label: {
                        Text("Activity types")
                    }, selectionLabel: { activityType in
                        Label(activityType.description, systemImage: activityType.iconSymbolName)
                    },
                                availableOptions: workoutManager.availableWorkoutActivityTypes,
                                selected: $workoutManager.selectedWorkoutActivityTypes,
                                navigationTitle: Text("Activity types"))
                    
                    DatePicker("Start date",
                               selection: $workoutManager.startDate,
                               in: Date.distantPast ... Date.now,
                               displayedComponents: [.date])
                    
                    DatePicker("End date",
                               selection: $workoutManager.endDate,
                               in: Date.distantPast ... Date.now,
                               displayedComponents: [.date])
                    
                }, header: {
                    Text("Filter")
                        .font(.headline)
                }, footer: {
                    Text("Date Filter Footer")
                })
                
                Section(content: {
                    Toggle("Include calories", isOn: $workoutManager.includeCaloriesInExport)
                }, header: {
                    Text("Export Options")
                        .font(.headline)
                }, footer: {
                    Text("Export Options Footer")
                })
                
                Section(content: {
                    Button("Read workouts", action: { workoutManager.isWorkoutListVisible = true })
                        
                }, header: {
                    Text("Export")
                        .font(.headline)
                }, footer: {
                    Text("Export Footer")
                })
                
                Section(content: {
                    Text("Import Text")
                        .fixedSize(horizontal: false, vertical: true)
                }, header: {
                    Text("Import")
                        .font(.headline)
                })
                
                Section {
                    Text("Version: \(Bundle.main.versionAndBuildNumber)")
                }
            }
            .navigationTitle("Workout Filter")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationDestination(isPresented: $workoutManager.isWorkoutListVisible, destination: {
                WorkoutListView()
            })
        }
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

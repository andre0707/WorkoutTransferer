//
//  WorkoutListView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import HealthKit
import SwiftUI

/// A list view which will display selectable workouts
struct WorkoutListView: View {
    
    /// Reference to the workout manager
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    
    /// The body of the view
    var body: some View {
        
        Group {
            if workoutManager.isReadingWorkouts {
                
                ProgressView("Reading workouts")
                
            } else {
                VStack {
                    List {
                        if workoutManager.workouts.isEmpty {
                            Text("No matching workouts")
                            
                        } else {
                            
                            ForEach($workoutManager.workouts) { $workout in
                                HStack {
                                    Image(systemName: workout.workoutActivityType.iconSymbolName)
                                    
                                    VStack(alignment: .leading) {
                                        Text(verbatim: "\(workout.workoutActivityType.description) - \(workout.data.formattedDistance)")
                                            .font(.headline)
                                        
                                        Text(verbatim: workout.data.formattedStartEnd)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        workout.isSelected.toggle()
                                    }, label: {
                                        Image(systemName: workout.isSelected ? "checkmark.circle" : "xmark.circle")
                                            .font(.largeTitle)
                                    })
                                }
                            }
                        }
                    }
                    Text("Select the workouts you want to export")
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Matching Workouts")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button("Workouts", systemImage: "figure.run.square.stack", action: {
                        workoutManager.exportSelectedWorkouts()
                    })
                    
                    Divider()
                    
                    Button("Routes (.gpx)", systemImage: "point.bottomleft.forward.to.point.topright.scurvepath", action: {
                        workoutManager.exportSelectedWorkoutRoutes()
                    })
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
                .disabled(workoutManager.workouts.isEmpty)
            }
        }
    }
}


// MARK: - Preview

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutListView()
                .environmentObject(WorkoutManager.preview)
        }
    }
}

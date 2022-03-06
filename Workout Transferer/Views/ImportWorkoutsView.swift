//
//  ImportWorkoutsView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import SwiftUI

/// A view which will be displayed when a .wotrfi file was opened with the app.
/// This view allows the user to select the workouts which should be imported.
/// There is also an option to cancel the import process
struct ImportWorkoutsView: View {
    
    /// Reference to the workout manager
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    /// The body of the view
    var body: some View {
        ZStack {
            Form {
                Section(content: {
                    List {
                    ForEach($workoutManager.workouts) { $workout in
                        WorkoutListCellView(isSelectable: true, workout: $workout)
                    }
                    }
                }, footer: {
                    Text("Select the workouts you want to import")
                })
            }
            
            if workoutManager.isImporting {
                Color(uiColor: UIColor.darkGray.withAlphaComponent(0.85))
                
                ProgressView("Importing workouts...")
                    .foregroundColor(.white)
            }
            
            if let importText = workoutManager.importingText {
                Color(uiColor: UIColor.darkGray.withAlphaComponent(0.85))
                Text(verbatim: importText)
                    .font(.title)
            }
        }
        
        .navigationTitle("Importing workouts")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Import")  {
                    workoutManager.importSelectedWorkouts()
                }
                .disabled(!workoutManager.isImportingButtonEnabled)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel")  {
                    workoutManager.cancelImport()
                }
                .disabled(!workoutManager.isCancelImportingButtonEnabled)
            }
        }
    }
}


// MARK: - Preview

struct ImportWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImportWorkoutsView()
                .environmentObject(WorkoutManager.preview)
        }
    }
}

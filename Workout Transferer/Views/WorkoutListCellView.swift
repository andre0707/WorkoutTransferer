//
//  WorkoutListCellView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import SwiftUI

/// A cell view for a workout item in a list
struct WorkoutListCellView: View {
    
    /// Indicator, if the cell can be selected or not
    let isSelectable: Bool
    
    /// Binding to the workout which should be displayed
    @Binding var workout: SelectableWorkout
    
    
    /// The body of the view
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(verbatim: "\(workout.data.workoutActivityType.description) - \(workout.data.formattedDistance)")
                    .font(.headline)
                
                Text(verbatim: workout.data.formattedStartEnd)
                    .font(.subheadline)
            }
            
            Spacer()
            
            if isSelectable {
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


// MARK: - Preview

struct WorkoutListCellView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            Section("Selectable") {
                ForEach(SelectableWorkout.preview) { workout in
                    WorkoutListCellView(isSelectable: true, workout: .constant(workout))
                }
            }
            
            Section("Not selectable") {
                ForEach(SelectableWorkout.preview) { workout in
                    WorkoutListCellView(isSelectable: false, workout: .constant(workout))
                }
            }
        }
    }
}

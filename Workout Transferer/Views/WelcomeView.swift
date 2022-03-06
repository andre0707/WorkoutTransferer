//
//  WelcomeView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import SwiftUI

/// A welcome view
struct WelcomeView: View {
    
    /// Reference to the workout manager
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    
    /// The body of the view
    var body: some View {
        ScrollView {
            VStack {
                Text("Welcome to *Workout Transferer*")
                    .font(.title)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("With this app you can transfer workouts with routes saved in Health from one device to another. Both devices need this app installed.\nThis is helpful if not everybody on for example a hike can record the workout with an own device, but would like to have the route saved as well.")
                    .padding()
                
                Text("*Workout Transferer* will need acces to your health data to read workouts. If you want to store transferred workouts, writing access is also needed.")
                    .padding()
                
                
                Button(action: {
                    Task {
                        await workoutManager.requestPermissionToHealthData()
                    }
                }, label: {
                    Text("Provide health access")
                        .padding()
                        .font(.title3)
                })
                    .buttonStyle(.borderedProminent)
                    .padding()
            }
        }
    }
}


// MARK: - Preview

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

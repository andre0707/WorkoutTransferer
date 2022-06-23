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
                
                Text("Welcome decription")
                    .padding()
                
                Text("Access needed text")
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
            .environmentObject(WorkoutManager.preview)
    }
}

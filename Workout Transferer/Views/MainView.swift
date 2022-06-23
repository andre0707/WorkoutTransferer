//
//  MainView.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import SwiftUI

/// The main view when the app starts
struct MainView: View {
    
    /// Reference to the workout manager
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    /// The different states the main view can have
    enum State {
        case displayWelcome
        case displayFilter
        case displayImport
    }
    
    /// The body of the view
    var body: some View {
        NavigationView {
            switch workoutManager.mainViewState {
            case .displayWelcome:
                WelcomeView()
                
            case .displayFilter:
                WorkoutFilterView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            Link(destination:
                                    URL(string: "http://aaindustries-apps.de/WorkoutTransferer/app_about_eng.html")!,
                                 label: {
                                Image(systemName: "info.circle")
                            })
                        })
                    }
                
            case .displayImport:
                ImportWorkoutsView()
            }
        }
    }
}


// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(WorkoutManager.preview)
    }
}

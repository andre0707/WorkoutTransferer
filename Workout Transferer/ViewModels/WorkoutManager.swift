//
//  WorkoutManager.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import Combine
import CoreLocation
import HealthKit
import os
import SwiftUI

/// A logger to log errors
fileprivate let logger = Logger(subsystem: Bundle.main.bundleIdentifier, category: "WorkoutManager")


/// The main view model which will coordinate the app
final class WorkoutManager: ObservableObject {
    
    // MARK: - UI Controls
    
    /// The main view state
    @Published var mainViewState: MainView.State = .displayFilter
    /// Indicator, if reading workouts with the set filter is currently running
    @Published private(set) var isReadingWorkouts: Bool = false
    
    /// Indicator, if the workout list is currently visible or not
    @Published var isWorkoutListVisible: Bool = false
    
    /// All the read workouts matching the set filter
    @Published var workouts: [SelectableWorkout] = []
    
    
    // MARK: - Filter options
    
    /// Only workouts after this date will be read
    @Published var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date.startOfToday)!
    /// Only workouts before this date will be read
    @Published var endDate: Date = Date.endOfToday
    
    /// Indicator, if calories count should be included when exporting workouts
    var includeCaloriesInExport: Bool = true
    
    
    /// Reference to all the subscriptions
    private var subscriptions: Set<AnyCancellable> = []
    
    /// Initialisation
    init() {
        $isWorkoutListVisible.sink { newValue in
            guard newValue else { return }
            Task { [weak self] in
                await self?.readWorkouts()
            }
        }
        .store(in: &subscriptions)
        
        $startDate
            .removeDuplicates()
            .sink { [unowned self] newValue in
                if newValue > self.endDate {
                    self.endDate = newValue.endOfTheDay
                }
            }
            .store(in: &subscriptions)
        
        $endDate
            .removeDuplicates()
            .sink { [unowned self] newValue in
                if newValue < self.startDate {
                    self.startDate = newValue.startOfTheDay
                }
            }
            .store(in: &subscriptions)
        
        
        Task {
            do {
                let status = try await healthStore.statusForAuthorizationRequest(toShare: writeSampleTypes, read: readObjectTypes)
                DispatchQueue.main.async {
                    self.mainViewState = status != .unnecessary ? .displayWelcome : .displayFilter
                }
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    
    // MARK: - User Interactions
    
    /// This function will read all the workouts matching the filter options
    func readWorkouts() async {
        DispatchQueue.main.async {
            self.isReadingWorkouts = true
        }
        defer {
            DispatchQueue.main.async {
                self.isReadingWorkouts = false
            }
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate.startOfTheDay, end: endDate.endOfTheDay, options: .strictStartDate)
        
        
        do {
            guard let readWorkouts = try await readWorkouts(with: predicate) else { return }
            
            var workoutsBuffer: [SelectableWorkout] = []
            for workout in readWorkouts {
                guard let workoutRoute = (try await workoutRoute(for: workout))?.first else { continue }
                
                let locations = try await locationData(for: workoutRoute)
                guard !locations.isEmpty else { continue }
                
                workoutsBuffer.append(SelectableWorkout(workout: workout, routeData: locations.map { WorkoutRouteData(from: $0) }))
            }
            
            DispatchQueue.main.async { [workoutsBuffer] in
                self.workouts = workoutsBuffer
            }
            
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
    }
    
    /// This function will export all the selected workouts
    func exportSelectedWorkouts() {
        let selectedWorkouts: [SelectableWorkout]
        
        if !includeCaloriesInExport {
            selectedWorkouts = workouts.filter { $0.isSelected }.map { SelectableWorkout(selectableWorkout: $0, includeCalories: false) }
        } else {
            selectedWorkouts = workouts.filter { $0.isSelected }
        }
        
        do {
            let jsonData = try JSONEncoder().encode(selectedWorkouts)
            
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("ExportedWorkouts.wotrfi")
            logger.debug("\(url, privacy: .public)")
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            try jsonData.write(to: url)
            
            logger.debug("\(url, privacy: .public)")
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Importing Workouts
    
    /// Text which will display information while importing takes place
    @Published private(set) var importingText: String? = nil
    
    /// This function will handle a file which was opened with this app
    /// - Parameter url: The url to the file which should be handled
    func handle(_ url: URL) {
        DispatchQueue.main.async {
            self.mainViewState = .displayImport
        }
        
        guard url.isFileURL, url.pathExtension == "wotrfi" else {
            importingText = "Failed to open: \(url.path)"
            isImportingButtonEnabled = false
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            workouts = try JSONDecoder().decode([SelectableWorkout].self, from: jsonData)
            isImportingButtonEnabled = true
        } catch {
            importingText = error.localizedDescription
            isImportingButtonEnabled = false
        }
    }
    
    /// Indicator, if the app is currently performing an import task
    @Published private(set) var isImporting: Bool = false
    /// Indicator, if the import toolbar button is enabled or not
    @Published private(set) var isImportingButtonEnabled: Bool = true
    /// Indicator, if the cancel import toolbar button is enabled or not
    @Published private(set) var isCancelImportingButtonEnabled: Bool = true
    
    /// User interaction to start the import of the selected workouts
    func importSelectedWorkouts() {
        isImporting = true
        isImportingButtonEnabled = false
        isCancelImportingButtonEnabled = false
        
        Task {
            for workout in workouts {
                do {
                    try await workout.saveToHealthStore()
                } catch {
                    logger.error("\(error.localizedDescription, privacy: .public)")
                }
            }
            DispatchQueue.main.async {
                self.isImportingButtonEnabled = true
                self.isCancelImportingButtonEnabled = true
                self.isImporting = false
                self.mainViewState = .displayFilter
            }
        }
    }
    
    /// User interaction to cancel the import of the selected workouts
    func cancelImport() {
        mainViewState = .displayFilter
    }
    
    
    // MARK: - Interaction Health Store
    
    /// Reference to the underlaying health store
    private let healthStore = HKHealthStore()
    
    /// All the sample types this app needs write access to
    private let writeSampleTypes: Set<HKSampleType> = [
        HKSeriesType.workoutRoute(),
        HKSeriesType.workoutType(),
        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
        HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!
    ]
    /// All the sample types this app wants read access to
    private let readObjectTypes: Set<HKObjectType> = [
        HKSeriesType.workoutRoute(),
        HKSeriesType.workoutType(),
        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
        HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!
    ]
    
    /// Use this function to request permission to health data
    func requestPermissionToHealthData() async {
        guard (try? await healthStore.requestAuthorization(toShare: writeSampleTypes, read: readObjectTypes)) != nil else { return }
        
        DispatchQueue.main.async {
            self.mainViewState = .displayFilter
        }
    }
    
    
    // MARK: - Read Workouts
    
    /// This function will asynchronously read the workouts matching the passed in `predicate`
    /// - Parameter predicate: The predicate which decides which workouts will be read
    /// - Returns: The matching workouts for the passed in `predicate`
    private func readWorkouts(with predicate: NSPredicate?) async throws -> [HKWorkout]? {
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }

        return workouts
    }
    
    /// This function will asynchronously read the route for the passed in `workout`.
    /// There can be multiple routes for every workout.
    /// - Parameter workout: The workout for which the route is needed
    /// - Returns: The routes objects for `workout`
    private func workoutRoute(for workout: HKWorkout) async throws -> [HKWorkoutRoute]? {
        let byWorkout = HKQuery.predicateForObjects(from: workout)

        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }

        return workouts
    }
    
    /// This function will asynchronously read the location data for the passed in `route`
    /// - Parameter route: The route for which the location data is needed
    /// - Returns: The location data fot `route`
    private func locationData(for route: HKWorkoutRoute) async throws -> [CLLocation] {
        let locations = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []

            // Create the route query.
            let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNil, done, errorOrNil) in

                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                    return
                }

                guard let currentLocationBatch = locationsOrNil else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                allLocations.append(contentsOf: currentLocationBatch)

                if done {
                    continuation.resume(returning: allLocations)
                }
            }

            healthStore.execute(query)
        }

        return locations
    }
}


// MARK: - Preview data

extension WorkoutManager {
    static let preview: WorkoutManager = {
        let manager = WorkoutManager()
        
        manager.workouts = SelectableWorkout.preview
//        manager.isImporting = true
        manager.importingText = "There was an error"
        
        return manager
    }()
}

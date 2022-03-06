//
//  SelectableWorkout.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import CoreLocation
import HealthKit

/// A helper structure which holds the workout data and the route together
struct SelectableWorkout: Codable {
    /// The underlaying workout data
    let data: HKWorkout
    /// The route belonging to the workout from `data`
    var route: [WorkoutRouteData]?
    
    /// Indicator, if this workout is currently selected in the lsit it is shown
    var isSelected: Bool = true
    
    
    /// Initialisation
    init(workout: HKWorkout, routeData: [WorkoutRouteData]? = nil) {
        self.data = workout
        self.route = routeData
    }
    
    init(selectableWorkout: SelectableWorkout, includeCalories: Bool) {
        if includeCalories {
            self.data = selectableWorkout.data
        } else {
            self.data = HKWorkout(activityType: selectableWorkout.data.workoutActivityType, start: selectableWorkout.data.startDate, end: selectableWorkout.data.endDate, workoutEvents: selectableWorkout.data.workoutEvents, totalEnergyBurned: nil, totalDistance: selectableWorkout.data.totalDistance, device: selectableWorkout.data.device, metadata: selectableWorkout.data.metadata)
        }
        
        self.route = selectableWorkout.route
        self.isSelected = selectableWorkout.isSelected
    }
    
    
    /// Coding
    enum CodingKeys: CodingKey {
        case type
        case startDate
        case endDate
        case energyBurned
        case totalDistance
        case locationData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data.workoutActivityType.rawValue, forKey: .type)
        try container.encode(data.startDate, forKey: .startDate)
        try container.encode(data.endDate, forKey: .endDate)
        try container.encode(data.totalEnergyBurned?.doubleValue(for: .kilocalorie()), forKey: .energyBurned)
        try container.encode(data.totalDistance?.doubleValue(for: .meter()), forKey: .totalDistance)
        try container.encode(route, forKey: .locationData)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = HKWorkoutActivityType(rawValue: try container.decode(UInt.self, forKey: .type)) else { throw HKError(.errorInvalidArgument) }
        let start = try container.decode(Date.self, forKey: .startDate)
        let end = try container.decode(Date.self, forKey: .endDate)
        
        
        let energy: HKQuantity?
        if let energyValue = try container.decodeIfPresent(Double.self, forKey: .energyBurned) {
            energy = HKQuantity(unit: .kilocalorie(), doubleValue: energyValue)
        } else {
            energy = nil
        }
        
        let distance: HKQuantity?
        if let distanceValue = try container.decodeIfPresent(Double.self, forKey: .totalDistance) {
            distance = HKQuantity(unit: .meter(), doubleValue: distanceValue)
        } else {
            distance = nil
        }
        
        let workout = HKWorkout(activityType: type,
                                start: start,
                                end: end,
                                duration: end.timeIntervalSince(start),
                                totalEnergyBurned: energy,
                                totalDistance: distance,
                                device: nil,
                                metadata: nil)
        data = workout
        route = try container.decode([WorkoutRouteData]?.self, forKey: .locationData)
    }
    
    /// This function will store `self` in the health store
    func saveToHealthStore() async throws {
        let healthStore = HKHealthStore()
        try await healthStore.save(data)
        
        guard let route = route else { return }
        let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        try await routeBuilder.insertRouteData(route.map { CLLocation(from: $0) })
        try await routeBuilder.finishRoute(with: data, metadata: nil)
    }
}

extension SelectableWorkout: Identifiable {
    var id: UUID { data.id }
}


// MARK: - Preview data

extension SelectableWorkout {
    static let preview: [SelectableWorkout] = {
        let hkWorkout1 = HKWorkout(activityType: .hiking, start: Date.now.addingTimeInterval(-60*24), end: Date.now)
        let hkWorkout2 = HKWorkout(activityType: .running, start: Date.now.addingTimeInterval(-60*24*3), end: Date.now.addingTimeInterval(-60*24*2))
        
        let selected1 = SelectableWorkout(workout: hkWorkout1, routeData: nil)
        var selected2 = SelectableWorkout(workout: hkWorkout2, routeData: nil)
        selected2.isSelected.toggle()
        
        return [selected1, selected2]
    }()
}

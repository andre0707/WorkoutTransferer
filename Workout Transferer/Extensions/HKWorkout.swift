//
//  HKWorkout.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import HealthKit

extension HKWorkout: Identifiable {
    public var id: UUID { uuid }
}

extension HKWorkout {
    /// A formatted string version of the duration
    var formattedStartEnd: String {
        (startDate ..< endDate).formatted(date: .numeric, time: .shortened)
    }
    
    /// A formatted string version of the distance
    var formattedDistance: String {
        guard let distance = totalDistance else { return "" }
        
        return Measurement(value: distance.doubleValue(for: .meter()), unit: UnitLength.meters).formatted()
    }
}

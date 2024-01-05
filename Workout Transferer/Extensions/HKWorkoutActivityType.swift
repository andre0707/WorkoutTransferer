//
//  HKWorkoutActivityType.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import HealthKit


extension HKWorkoutActivityType: Identifiable {
    public var id: UInt { rawValue }
}


extension HKWorkoutActivityType: CustomStringConvertible {
    /// The description of the activity type
    public var description: String {
        switch self {
        case .walking: return String(localized: "Walking")
        case .running: return String(localized: "Running")
        case .hiking: return String(localized: "Hiking")
        case .cycling: return String(localized: "Cycling")
        case .swimming: return String(localized: "Swimming")
        case .wheelchairWalkPace: return String(localized: "Wheelchair Walk Pace")
        case .wheelchairRunPace: return String(localized: "Wheelchair Run Pace")
        default: return String(localized: "Unknown", comment: "")
        }
    }
}


extension HKWorkoutActivityType: Comparable {
    public static func < (lhs: HKWorkoutActivityType, rhs: HKWorkoutActivityType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


extension HKWorkoutActivityType: Codable { }

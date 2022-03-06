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
    public var description: String {
        switch self {
        case .walking: return "Walking"
        case .running: return "Running"
        case .hiking: return "Hiking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .wheelchairWalkPace: return "Wheelchair Walk Pace"
        case .wheelchairRunPace: return "Wheelchair Run Pace"
        default: return "Unknown"
        }
    }
}


extension HKWorkoutActivityType: Comparable {
    public static func < (lhs: HKWorkoutActivityType, rhs: HKWorkoutActivityType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


extension HKWorkoutActivityType: Codable { }

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
        case .walking: return NSLocalizedString("Walking", comment: "")
        case .running: return NSLocalizedString("Running", comment: "")
        case .hiking: return NSLocalizedString("Hiking", comment: "")
        case .cycling: return NSLocalizedString("Cycling", comment: "")
        case .swimming: return NSLocalizedString("Swimming", comment: "")
        case .wheelchairWalkPace: return NSLocalizedString("Wheelchair Walk Pace", comment: "")
        case .wheelchairRunPace: return NSLocalizedString("Wheelchair Run Pace", comment: "")
        default: return NSLocalizedString("Unknown", comment: "")
        }
    }
}


extension HKWorkoutActivityType: Comparable {
    public static func < (lhs: HKWorkoutActivityType, rhs: HKWorkoutActivityType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


extension HKWorkoutActivityType: Codable { }

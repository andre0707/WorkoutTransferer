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
        case .swimBikeRun: return String(localized: "Triathlon")
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


extension HKWorkoutActivityType {
    /// The icon symbol name from SF-Symbols
    public var iconSymbolName: String {
        switch self {
        case .walking: return "figure.walk"
        case .running: return "figure.run"
        case .hiking: return "figure.hiking"
        case .cycling: return "figure.outdoor.cycle"
        case .swimming: return "figure.open.water.swim"
        case .wheelchairWalkPace: return "figure.roll"
        case .wheelchairRunPace: return "figure.roll.runningpace"
        case .swimBikeRun: return "medal"
        case .other: return "questionmark"
        default: return "questionmark"
        }
    }
}

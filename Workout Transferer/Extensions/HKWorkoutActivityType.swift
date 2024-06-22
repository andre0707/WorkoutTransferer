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
        case .paddleSports: return String(localized: "Paddle sports")
        case .crossCountrySkiing: return String(localized: "Cross country skiing")
        case .rowing: return String(localized: "Outdoor rowing")
        case .golf: return String(localized: "Golf")
        case .downhillSkiing: return String(localized: "Downhill skiing")
        case .snowboarding: return String(localized: "Snowboarding")
        case .skatingSports: return String(localized: "Outdoor skating")
        case .other: return String(localized: "Other")
        default: return String(localized: "Unknown")
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
        case .paddleSports: return "oar.2.crossed"
        case .crossCountrySkiing: return "figure.skiing.crosscountry"
        case .rowing: return "figure.rower"
        case .golf: return "figure.golf"
        case .downhillSkiing: return "figure.skiing.downhill"
        case .snowboarding: return "figure.snowboarding"
        case .skatingSports: return "figure.skating"
        case .other: return "questionmark"
        default: return "questionmark"
        }
    }
}

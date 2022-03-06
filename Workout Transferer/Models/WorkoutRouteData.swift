//
//  WorkoutRouteData.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import CoreLocation

/// A helper structure to store a single workout route data point
struct WorkoutRouteData: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let timeStamp: Date
}

extension WorkoutRouteData {
    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.timeStamp = location.timestamp
    }
}

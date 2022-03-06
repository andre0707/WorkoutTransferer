//
//  CLLocation.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.03.22.
//

import CoreLocation


extension CLLocation {
    convenience init(from workoutRouteData: WorkoutRouteData) {
        self.init(coordinate: CLLocationCoordinate2D(latitude: workoutRouteData.latitude, longitude: workoutRouteData.longitude),
                  altitude: workoutRouteData.altitude,
                  horizontalAccuracy: 1,
                  verticalAccuracy: 1,
                  timestamp: workoutRouteData.timeStamp)
    }
}

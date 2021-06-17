//
//  CLLocationCoordinate2DExtension.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 14/05/21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    /// Returns distance from coordianate in meters.
    /// - Parameter from: coordinate which will be used as end point.
    /// - Returns: Returns distance in meters.
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}

/* Explaination of the above function
 point1(currentLocation): CLLocationCoordinate2D, point2(officeLocation --> from Database): CLLocationCoordinate2D
 
 point1(currentLocation).distance(point2)
 
 let point2(officeLocation) = CLLocation(latitude: point2officeLocation).latitude, longitude: point2officeLocation).longitude)
 let point1(currentLocation) = CLLocation(latitude: point1(currentLocation).latitude, longitude: point1(currentLocation).longitude)
 
  point2.distance(from: point1)
 */

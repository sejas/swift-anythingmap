//
//  StudentLocation.swift
//  baumap
//
//  Created by Antonio Sejas on 26/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import MapKit

struct StudentLocation {
    var coordinate: CLLocationCoordinate2D
    var firstName: String
    var lastName: String
    var mediaURL:  String
    var updatedAt:  String
    var createdAt:  String
    
    init(fromDictionary: NSDictionary) {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(fromDictionary["latitude"] as! Double)
        let long = CLLocationDegrees(fromDictionary["longitude"] as! Double)
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        firstName = fromDictionary["firstName"] as! String
        lastName = fromDictionary["lastName"] as! String
        mediaURL = fromDictionary["mediaURL"] as! String
        updatedAt = fromDictionary["updatedAt"] as! String
        createdAt = fromDictionary["createdAt"] as! String
    }
}
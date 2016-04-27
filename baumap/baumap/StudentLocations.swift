//
//  StudentLocations.swift
//  baumap
//
//  Created by Antonio Sejas on 26/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class StudentLocations: NSObject {
    //Shared locations to show them in the map and in the list
    var locations:[StudentLocation] = []
    
    func saveAndReturnLocations(locationsJSON: [[String : AnyObject]]) -> [StudentLocation] {
        locations = []
        
        for dictionary in locationsJSON {
            locations.append(StudentLocation(fromDictionary: dictionary))
        }
        
        return locations
    }
    
    func getLocations() -> [StudentLocation] {
        return locations
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        return Singleton.sharedInstance
    }
}

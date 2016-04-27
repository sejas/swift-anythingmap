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
    
    func getCachedLocations() -> [StudentLocation] {
        return locations
    }
    
    func downloadLocationsWithCompletion(completionHandler:(locations: [StudentLocation], error: NSError? ) -> Void) {
        ParseClient.sharedInstance().getStudentLocations { (result, error) in
            guard nil == error else {
                print("Error receiving the student locations",error)
                let userInfo = [NSLocalizedDescriptionKey : "Error receiving the student locations"]
                completionHandler(locations: [StudentLocation](), error: NSError(domain: "downloadLocationsWithCompletion", code: 1, userInfo: userInfo))
                return
            }
            print("getParseLocations: ",result)
            let locations = self.saveAndReturnLocations(result["results"] as! [[String : AnyObject]])
            completionHandler(locations: locations, error: nil)
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        return Singleton.sharedInstance
    }
}

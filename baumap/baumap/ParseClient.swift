//
//  ParseClient.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import CoreLocation

class ParseClient: NSObject {
    //MARK: Constants
    struct Constants {
        // MARK: URLs
        static let BaseURL: String = "https://api.parse.com/1/classes/"
        static let URLStudentLocations: String = BaseURL+"StudentLocation"
        static let ApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDHeaderKey: String = "X-Parse-Application-Id"
        static let APIKeyHeaderKey: String = "X-Parse-REST-API-Key"
    }
    let headersAuth = [
        Constants.ApplicationIDHeaderKey: Constants.ApplicationID,
        Constants.APIKeyHeaderKey: Constants.APIKey
    ]
    
    //MARK: REST API Methods
    func getStudentLocations(completionHandler: (result: AnyObject!, error: NSError?) -> Void){
        NetworkHelper.sharedInstance().getRequest(Constants.URLStudentLocations, headers: headersAuth, completionHandlerForGET: completionHandler)
    }
    
    func postStudentLocations(user: NSDictionary, placeString: String, mediaURL: String, coordinates: CLLocationCoordinate2D, completionHandler: (result: AnyObject!, error: NSError?) -> Void){
        guard
            let user = user["user"],
            let uniqueKey = user["key"],
            let firstName = user["first_name"],
            let lastName = user["last_name"] else {
                let userInfo = [NSLocalizedDescriptionKey : "Error parsin User, missing fields"]
                let error = NSError(domain: "postStudentLocations", code: 1, userInfo: userInfo)
                completionHandler(result: error, error: error)
                return
        }
        
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey!)\", \"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(placeString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinates.latitude), \"longitude\": \(coordinates.longitude)}"
        print("postStudentLocations",jsonBody)
        NetworkHelper.sharedInstance().postRequest(Constants.URLStudentLocations, headers: headersAuth, jsonBody: jsonBody, completionHandlerForPOST: completionHandler)
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    
}

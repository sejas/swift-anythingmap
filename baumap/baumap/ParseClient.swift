//
//  ParseClient.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    //MARK: Constants
    struct Constants {
        // MARK: URLs
        static let BaseURL: String = "https://api.parse.com/1/classes/"
        static let URLStudentLocation: String = BaseURL+"StudentLocation"
        static let ApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDHeaderKey: String = "X-Parse-Application-Id"
        static let APIKeyHeaderKey: String = "X-Parse-REST-API-Key"
    }
    
    func getStudentLocations(completionHandler: (result: AnyObject!, error: NSError?) -> Void){
        let headers = [
            Constants.ApplicationID: Constants.ApplicationIDHeaderKey,
            Constants.APIKey: Constants.APIKeyHeaderKey
        ]
        NetworkHelper.sharedInstance().getRequest(Constants.URLStudentLocation, headers: headers, completionHandlerForGET: completionHandler)
        
    }
}

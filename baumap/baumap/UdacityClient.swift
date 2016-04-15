//
//  UdacityClient.swift
//  baumap
//
//  Created by Antonio Sejas on 15/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    //MARK: Constants
    struct Constants {
        // MARK: URLs
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"
    }
    
    // MARK: POST
/*
 *Method Type: POST
 *Required Parameters:
 *udacity - (Dictionary) a dictionary containing a username (email) and password pair used for authentication
 *username - (String) the username (email) for a Udacity student
 *password - (String) the password for a Udacity student
*/
    func authenticate(user: String, password: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.AuthorizationURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "authenticate", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil,
                let data = data else {
                sendError("Error while trying to authenticate: \(error)")
                return
            }
   
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let stringResonse = NSString(data: newData, encoding: NSUTF8StringEncoding)
            print(stringResonse)
            completionHandler(result: stringResonse, error: nil)
            
        }
        task.resume()

        
        return task
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

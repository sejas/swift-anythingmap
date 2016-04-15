//
//  UdacityClient.swift
//  baumap
//
//  Created by Antonio Sejas on 15/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
struct udacitySession {
    var session_id: String
    var account_key: String
    var expiration: String
}
class UdacityClient: NSObject {
    //MARK: Constants
    struct Constants {
        // MARK: URLs
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"
        static let NSDefaultsKeyForSession: String = "udacitySession"
    }
    
    let prefs = NSUserDefaults.standardUserDefaults()
    let udacitySessionError = udacitySession(session_id: "",account_key: "",expiration: "")
    
    // MARK: POST
/*
* Make the POST CALL TO THE UDACITY API and return a valid session or error
* Method Type: POST {udacity:{username:"",password:""}}
*/
    func authenticate(email: String, password: String, completionHandler: (result: udacitySession, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.AuthorizationURL)!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: self.udacitySessionError, error: NSError(domain: "authenticate", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: {(result, error) in
                self.parseAuthenticationWithCompletionHandler(result as? NSDictionary, completionHandler: completionHandler)
            })
        }
        task.resume()

        
        return task
    }
    
    //Parse and validate a JSON to return a valid Session or Error. Is a self.authenticate helper
    func parseAuthenticationWithCompletionHandler(authJson: NSDictionary?, completionHandler: (result: udacitySession,error: NSError?) -> Void) {
        guard let account = authJson!["account"],
            let account_key = account["key"] as? String,
            let session = authJson!["session"],
            let expiration = session["expiration"] as? String,
            let session_id = session["id"] as? String else {
                let userInfo = [NSLocalizedDescriptionKey : "Error wrong user password"]
                completionHandler(result: self.udacitySessionError, error: NSError(domain: "authenticate", code: 1, userInfo: userInfo))
                return
        }
        
        completionHandler(result: udacitySession(session_id: session_id, account_key: account_key, expiration: expiration), error: nil)
    }
    
    
    // Transform NSData returning a JSON Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK: NSDefaults to save and restore the session
    func saveSession(session: udacitySession) {
        prefs.setValue(session.session_id, forKey: Constants.NSDefaultsKeyForSession)
        prefs.setValue(session.expiration, forKey: "\(Constants.NSDefaultsKeyForSession)Expiration")
    }
    func loadSessionID() -> String? {
        guard let session_id = prefs.stringForKey(Constants.NSDefaultsKeyForSession) else{
            return nil
        }
        //TODO: Check if it is expired
        return session_id
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

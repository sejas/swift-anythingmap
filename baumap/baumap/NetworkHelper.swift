//
//  NetworkHelper.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class NetworkHelper: NSObject {
    // shared session
    var session = NSURLSession.sharedSession()
    
    // MARK: GET
    func getRequest(urlString: String, headers: [String:String]?, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        guard let url = NSURL(string: urlString) else {
            let userInfo = [NSLocalizedDescriptionKey : "Error parsin URL \(urlString)"]
            completionHandlerForGET(result: nil, error: NSError(domain: "NetworkHelper", code: 1, userInfo: userInfo))
            return NSURLSessionDataTask()
        }
        
        let request = requestFromHeaders(url, headers: headers)
        return requestHelper(request, completionHandler: completionHandlerForGET)
    }
    
    // MARK: POST
    func postRequest(urlString: String, headers: [String:String]?, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        guard let url = NSURL(string: urlString) else {
            let userInfo = [NSLocalizedDescriptionKey : "Error parsin URL \(urlString)"]
            completionHandlerForPOST(result: nil, error: NSError(domain: "NetworkHelper", code: 1, userInfo: userInfo))
            return NSURLSessionDataTask()
        }
        
        let request = requestFromHeaders(url, headers: headers)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        return requestHelper(request, completionHandler: completionHandlerForPOST)
    }
    
    // MARK: Request helper
    private func requestHelper(request: NSURLRequest, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "NetworkHelper", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
        }
        task.resume()
        
        return task
    }
    //MARK: Helpers
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "NetworkHelper", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // add headers to mutable request
    private func requestFromHeaders(URL: NSURL, headers: [String:String]?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL:URL)
        guard let headers = headers else {
            return request
        }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> NetworkHelper {
        struct Singleton {
            static var sharedInstance = NetworkHelper()
        }
        return Singleton.sharedInstance
    }
}

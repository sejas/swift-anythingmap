//
//  CustomActivityIndicator.swift
//  baumap
//
//  Created by Antonio Sejas on 10/5/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class CustomActivityIndicator: NSObject {
    var activityIndicator = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    func show (that:UIViewController) {
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = that.view.center
        loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
//        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        performUIUpdatesOnMain {
            self.loadingView.addSubview(self.activityIndicator)
            that.view.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hide () {
        performUIUpdatesOnMain {
            self.loadingView.removeFromSuperview()
        }
    }
    
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> CustomActivityIndicator {
        struct Singleton {
            static var sharedInstance = CustomActivityIndicator()
        }
        return Singleton.sharedInstance
    }
}

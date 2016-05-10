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
    
    func show (that:UIViewController) {
        let width = that.view.frame.size.width
        let height: CGFloat = that.view.frame.size.height
        let activityIndicatorSize: CGFloat = 40
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: width / 2 - activityIndicatorSize, y: height / 2 - activityIndicatorSize / 2, width: activityIndicatorSize, height: activityIndicatorSize)
        activityIndicator.startAnimating()
        performUIUpdatesOnMain { 
            that.view.addSubview(self.activityIndicator)
        }
    }
    
    func hide () {
        performUIUpdatesOnMain {
            self.activityIndicator.removeFromSuperview()
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

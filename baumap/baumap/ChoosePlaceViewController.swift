//
//  ChoosePlaceViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import CoreLocation

class ChoosePlaceViewController: UIViewController {
    @IBOutlet weak var btnFindOnMap: CustomButton!
    @IBOutlet weak var tfLocation: UITextField!
    
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var placeString:String = ""
    
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLocation.delegate = textFieldDelegate
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func actionFindOnMap(sender: AnyObject) {
        guard let placeString = tfLocation.text else {
            print("Error, No text in text field Location")
            return
        }
        //Convert string to coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(tfLocation.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            guard nil == error else {
                print("Address not found geocodeAddressString: ",error)
                return
            }
            guard let placemark = placemarks?.first,
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate else {
                    print("Address not found")
                    return
            }
            //            print("placemarks",placemarks)
            print("coordinates",coordinates)
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewControllerWithIdentifier("AddLinkView") as! AddLinkViewController
//            vc.coordinates = coordinates
//            vc.placeString = placeString
            
            self.coordinates = coordinates
            self.placeString = placeString
            performUIUpdatesOnMain({
//                                self.dismissViewControllerAnimated(false, completion: nil)
//                                self.presentViewController(vc, animated: false, completion: nil)
                
                self.performSegueWithIdentifier("toAddLink", sender: nil)
            })
        })
        
        //        performSegueWithIdentifier("toAddLink", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! AddLinkViewController
        vc.coordinates = coordinates
        vc.placeString = placeString
        
    }
    
    
}

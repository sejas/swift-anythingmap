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
            CustomAlert.sharedInstance().showError(self, title: "", message: "Error, No text in text field Location")
            return
        }
        //Convert string to coordinates
        CustomActivityIndicator.sharedInstance().show(self)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(tfLocation.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            CustomActivityIndicator.sharedInstance().hide()
            guard nil == error else {
                print("Address not found: ",error)
                CustomAlert.sharedInstance().showError(self, title: "", message: "Address not found: \(error!.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first,
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate else {
                    print("Address not found")
                    CustomAlert.sharedInstance().showError(self, title: "", message: "Address not found.")
                    return
            }
            //            print("placemarks",placemarks)
            print("coordinates",coordinates)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("AddLinkView") as! AddLinkViewController
            vc.coordinates = coordinates
            vc.placeString = placeString
            performUIUpdatesOnMain({
                self.presentViewController(vc, animated: true, completion: nil)
                
            })
        })
    }
    
    
    //Mark: Keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tfLocation.resignFirstResponder()        
    }
}

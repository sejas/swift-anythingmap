//
//  AddLinkViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 17/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLinkViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var tfLink: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var placeString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLink.delegate = textFieldDelegate
        addLocationMap()
    }
    
    // MARK: MAP
    func addLocationMap() {
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinates
        annotation.title = placeString
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        map.addAnnotations(annotations)
        map.setCenterCoordinate(self.coordinates, animated: false)
        setZoomMap(self.coordinates)
    }
    func setZoomMap(coordinate:CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2100, 2100);
        map.setRegion(viewRegion,animated: false)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    
    
    @IBAction func actionClose(sender: AnyObject) {
        //Hide parent viewcontroller
         self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func actionSubmit(sender: AnyObject) {
        guard let mediaURL = tfLink.text else {
            print("Error, No text in text field Location")
            return
        }
        //Get user info
        UdacityClient.sharedInstance().getPublicDataFromUserID() { (result, error) in
            guard error == nil else {
                print("we couldn't get user info",error)
                return
            }
            guard let userInfo = result as? NSDictionary else {
                print("user info is not dictionary",error)
                return
            }
            
            //Save location into Parse
            ParseClient.sharedInstance().postStudentLocations(userInfo, placeString: self.placeString, mediaURL: mediaURL, coordinates: self.coordinates, completionHandler: { (result, error) in
                guard error == nil else {
                    print("Error saving location into Parse",error)
                    return
                }
                
                print("Success location saved into Parse",result)
                performUIUpdatesOnMain({ 
                    self.actionClose(false)
                })
            })
            print("result getPublicDataFromUserID", result)
        }
        
    }
    //Mark: Keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tfLink.resignFirstResponder()
    }
}

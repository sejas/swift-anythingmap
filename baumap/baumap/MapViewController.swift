//
//  MapViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 15/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get locations from api
        getParseLocationsAndRefreshMap()
        
    }
    
    // MARK: MAP
    func updateLocationsMap() {
        //Delete old annotations if there were some
        performUIUpdatesOnMain({
            self.map.removeAnnotations(self.map.annotations)
        })
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for oneLocation in locations {
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = oneLocation.coordinate
            annotation.title = "\(oneLocation.firstName) \(oneLocation.lastName)"
            annotation.subtitle = oneLocation.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        performUIUpdatesOnMain({
            // When the array is complete, we add the annotations to the map.
            self.map.addAnnotations(annotations)
        })
    }
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    
    
    
    //MARK: Network Request
    func getParseLocationsAndRefreshMap() {
        ParseClient.sharedInstance().getStudentLocations { (result, error) in
            guard nil == error else {
                print("Error receiving the student locations",error)
                self.showError("", message: "Error receiving the student locations")
                return
            }
            
            print("getParseLocations: ",result)
            //TODO: validate response result
            self.locations = StudentLocations.sharedInstance().saveAndReturnLocations(result["results"] as! [[String : AnyObject]])
            self.updateLocationsMap()
        }
    }
   
    //MARK: UserInteractions
    @IBAction func actionLogout(sender: AnyObject) {
        UdacityClient.sharedInstance().logout({(result,error) in
            guard nil == error else {
                self.showError("",message: "Sorry we couldn't make the logout")
                return
            }
            performUIUpdatesOnMain({self.dismissViewControllerAnimated(true, completion: nil)})
            //navigationController?.popToRootViewControllerAnimated(true)
            print(result)
            print(error)
        })
        
    }
    @IBAction func actionGeoLocate(sender: AnyObject) {
        performSegueWithIdentifier("toChoosePlace", sender: "")
    }
    @IBAction func actionUpdate(sender: AnyObject) {
        getParseLocationsAndRefreshMap()
    }
    
    // Mark: General Helpers
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        performUIUpdatesOnMain({self.presentViewController(alertController, animated: true, completion: nil)})
    }
}

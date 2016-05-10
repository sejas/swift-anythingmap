//
//  TableObjectesViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 13/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class TableObjectesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var locations: [StudentLocation] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getParseLocationsAndRefreshTable()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(actionUpdate), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Network Request
    func getParseLocationsAndRefreshTable() {
        StudentLocations.sharedInstance().downloadLocationsWithCompletion { (locations, error) in
            guard nil == error else {
                print("Error receiving the student locations",error)
                CustomAlert.sharedInstance().showError(self, title: "", message: "Error receiving the student locations")
                performUIUpdatesOnMain({ 
                    self.refreshControl.endRefreshing()
                })
                return
            }

            //The table is sorted in order of most recent to oldest update.
            self.locations = locations.sort { $0.updatedAt > $1.updatedAt }
            performUIUpdatesOnMain({ 
                self.table.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    
    //MARK: Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection: \(locations.count)")
        return locations.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellPlace")! as! CellPlace
        let location = locations[indexPath.row]
        cell.lblName.text = "\(location.firstName) \(location.lastName)"
        cell.lblLink.text = "\(location.mediaURL)"
        return cell
    }
    
    //MARK: UserInteractions
    @IBAction func actionLogout(sender: AnyObject) {
        UdacityClient.sharedInstance().logout({(result,error) in
            guard nil == error else {
                CustomAlert.sharedInstance().showError(self, title: "", message: "Sorry we couldn't make the logout")
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
        getParseLocationsAndRefreshTable()
    }
    //MARK: Tap on Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        table.deselectRowAtIndexPath(indexPath, animated: true)
        NetworkHelper.sharedInstance().openURLSafari(locations[indexPath.row].mediaURL) {
            CustomAlert.sharedInstance().showError(self, title: "", message: "Invalid URL")
        }
    }
    
}

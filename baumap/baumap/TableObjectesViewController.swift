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
        refreshControl.addTarget(self, action: Selector("refreshTable:"), forControlEvents: UIControlEvents.ValueChanged)
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
                self.showError("", message: "Error receiving the student locations")
                performUIUpdatesOnMain({ 
                    self.refreshControl.endRefreshing()
                })
                return
            }
            self.locations = locations
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
        cell.lblName.text = "\(locations[indexPath.row].firstName) \(locations[indexPath.row].lastName)"
        return cell
    }
    func refreshTable(sender:AnyObject) {
        getParseLocationsAndRefreshTable()
    }
    
    //MARK: Segues
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        table.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("toObjectDetail", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if("toObjectDetail" == segue.identifier){
            
        }
    }

    // Mark: General Helpers
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        performUIUpdatesOnMain({self.presentViewController(alertController, animated: true, completion: nil)})
    }
    
}

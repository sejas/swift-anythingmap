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
    
    var objects = ["Uno","Dos", "Tres"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: ObjectCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ObjectCell")! //as! TableMemesTableViewCell
        cell.textLabel?.text = objects[indexPath.row]
        return cell
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


}

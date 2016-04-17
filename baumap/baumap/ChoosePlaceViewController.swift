//
//  ChoosePlaceViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

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
//        performSegueWithIdentifier("toAddLink", sender: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AddLinkView")
        presentViewController(vc, animated: false, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        [[self view] addSubview:newSubView];
        //        [oldView removeFromSuperview];
//        let viewAddLink = segue.destinationViewController as! AddLinkViewController
//        self.view.addSubview(viewAddLink)
    }
}

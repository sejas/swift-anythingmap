//
//  ChoosePlaceViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 16/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class ChoosePlaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

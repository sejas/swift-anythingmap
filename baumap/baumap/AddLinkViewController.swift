//
//  AddLinkViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 17/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class AddLinkViewController: UIViewController {
    
    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var tfLink: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLink.delegate = textFieldDelegate
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func actionSubmit(sender: AnyObject) {
        print("Submit")
    }

}

//
//  ViewController.swift
//  baumap
//
//  Created by Antonio Sejas on 1/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func actionLogin(sender: AnyObject) {
        //TODO: check the email password with api
        performSegueWithIdentifier("toTabView", sender: nil)
    }
    @IBAction func actionFacebookLogin(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}


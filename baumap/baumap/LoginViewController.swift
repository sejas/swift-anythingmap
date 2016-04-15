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
        guard let email = tfEmail.text,
            let password = tfPassword.text else {
                //TODO: Inform the error in credentials
                return
        }
        print("loging with user\(email) password:\(password)")
        UdacityClient.sharedInstance().authenticate(email, password: password) { (result, error) in
            print("result",result)
            print("error",error)
        }
        
        //TODO: Uncomment after login
        //performSegueWithIdentifier("toTabView", sender: nil)
    }
    @IBAction func actionFacebookLogin(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}


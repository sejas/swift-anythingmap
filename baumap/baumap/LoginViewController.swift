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
        //Clean data
        guard let email = tfEmail.text,
            let password = tfPassword.text else {
                showError("Error", message: "Please fill your user password")
                return
        }
        
        print("loging with user\(email) password:\(password)")
        UdacityClient.sharedInstance().authenticate(email, password: password) { (session, error) in
            guard nil == error else {
                self.showError("Error", message: "Error: \(error)")
                print("error",error)
                return
            }
            print(session)
            self.performSegueWithIdentifier("toTabView", sender: session.session_id)
        }
    }
    @IBAction func actionFacebookLogin(sender: AnyObject) {
        //TODO: Facebook login
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}


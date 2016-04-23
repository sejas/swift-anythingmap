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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryAutoLogin()
    }
    
    // Mark: Logins
    func tryAutoLogin() {
        guard let session_id = UdacityClient.sharedInstance().loadSessionID() else {
            return
        }
        
        performUIUpdatesOnMain({
            self.performSegueWithIdentifier("toTabView", sender: session_id)
        })
    }
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
                self.showError("Error", message: "Error: \(error?.localizedDescription)")
                print("error",error)
                return
            }
            
            print(session)
            //Save session for autologin
            UdacityClient.sharedInstance().saveSession(session, email: email)
            performUIUpdatesOnMain({
                self.tfEmail.text = ""
                self.tfPassword.text = ""
                
                self.performSegueWithIdentifier("toTabView", sender: session.session_id)
            })
        }
    }
    @IBAction func actionFacebookLogin(sender: AnyObject) {
        //TODO: Facebook login
    }
    
    // Mark: General Helpers
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        performUIUpdatesOnMain({self.presentViewController(alertController, animated: true, completion: nil)})
    }

}


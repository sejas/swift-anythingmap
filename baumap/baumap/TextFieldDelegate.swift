//
//  TextFieldDelegate.swift
//  baumap
//
//  Created by Antonio Sejas on 17/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
        // To choose your placeholder, just set a Tag on TextField
        struct placeholders {
            let location =  "Enter Your Location Here"
            let link =  "Enter a Link to Share Here"
        }
        enum textFieldTag: Int {case location = 1, link}
        
        var stringConstants = placeholders()
        
        func textFieldDidBeginEditing(textField: UITextField) {
            if( stringConstants.location == textField.text
                || stringConstants.link == textField.text ){
                textField.text = ""
            }
        }
        
        func textFieldDidEndEditing(textField: UITextField) {
            if("" == textField.text){
                resetTextFromTextField(textField)
            }
        }
        
        func textFieldShouldEndEditing(textField: UITextField) -> Bool {
            return true
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            //Hide the keyboard
            textField.resignFirstResponder()
            return true
        }
        
        //Also is called from ViewController
        func resetTextFromTextField(textField: UITextField) {
            if(textField.tag == textFieldTag.location.rawValue){
                textField.text = stringConstants.location
            }else{
                textField.text = stringConstants.link
            }
        }
}

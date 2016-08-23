//
//  AuthenticationViewController.swift
//  intertview
//
//  Created by steven lee on 16/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class AuthenticationViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var codeTextField: UITextField!
    
    var email = ""
    var name = ""
    var userID = ""
    var phoneNumber = ""
    var password = ""
    var verificationCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
       codeTextField.removeBorder()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        registerForKeyboardNotifications()
        
        let authenticationModel = AuthenticationModel()
        authenticationModel.sendSMS(phoneNumber)
        verificationCode = String(authenticationModel.token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        // Rejoin these components
        let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
        
        //To limit the input
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length

        
        return string == filtered && newLength <= 4
    }
    
    
    @IBAction func onResendCode(sender: AnyObject) {
        let authenticationModel = AuthenticationModel()
        authenticationModel.sendSMS(phoneNumber)
        verificationCode = String(authenticationModel.token)
    }
    @IBAction func onVerify(sender: AnyObject) {
        
        if(verificationCode == codeTextField.text) {
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
                let dataBaseModel = DatabaseModel()
                dataBaseModel.sendToDatabase(self.email, name: self.name , phone: self.phoneNumber, picture: "", userID: (user?.uid)!)
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("UploadPictureViewContoller") as! UploadPictureViewContoller
                controller.userID = (user?.uid)!
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }    }
    

}

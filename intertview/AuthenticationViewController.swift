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
class AuthenticationViewController: UIViewController {

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
       codeTextField.removeBorder()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        registerForKeyboardNotifications()
        
        let authenticationModel = AuthenticationModel()
        authenticationModel.sendSMS()
        verificationCode = String(authenticationModel.token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onResendCode(sender: AnyObject) {
        let authenticationModel = AuthenticationModel()
        authenticationModel.sendSMS()
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

//
//  LoginViewController.swift
//  intertview
//
//  Created by steven lee on 15/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var emailMessageLabel: UILabel!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    
    let rootRef = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.removeBorder()
        userPasswordTextField.removeBorder()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func onBeginEditing(sender: UITextField) {
        sender.placeholder = ""
        if sender == userNameTextField {
            emailLabel.hidden = false
        }
        else {
         passwordLabel.hidden = false
        }
        
    }
    
    @IBAction func onEndEditing(sender: UITextField) {
        if sender.text == "" {
            if sender == userNameTextField {
                sender.placeholder = "Email Address"
                emailLabel.hidden = true
            }
            else {
                sender.placeholder = "Password"
                passwordLabel.hidden = true
            }
        }
    }
    
    
    @IBAction func onSignIn(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(userNameTextField.text!, password: userPasswordTextField.text!, completion: { (user:FIRUser?, error: NSError?) in
            if(error == nil){
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
                controller.userID = (user?.uid)!
                self.presentViewController(controller, animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription)
            }
        })
        
    }
    
}

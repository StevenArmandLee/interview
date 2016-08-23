//
//  RegisterViewController.swift
//  intertview
//
//  Created by steven lee on 15/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreTelephony
import PhoneNumberKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: PhoneNumberTextField!
  
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var nameMessageLabel: UILabel!
    @IBOutlet weak var emailMesageLabel: UILabel!
    @IBOutlet weak var mobileNumberMessageNumber: UILabel!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.removeBorder()
        emailTextField.removeBorder()
        mobileNumberTextField.removeBorder()
        passwordTextField.removeBorder()
        mobileNumberTextField.delegate = self
        mobileNumberTextField.text = "+"+getPhoneCountryCode()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersInString:"0123456789+").invertedSet
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        // Rejoin these components
        let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }
    func removeAllMessageLabel() {
        nameMessageLabel.hidden = true
        emailMesageLabel.hidden = true
        mobileNumberMessageNumber.hidden = true
        passwordMessageLabel.hidden = true
    }
    
    func checkIfEmptyInput() -> Bool {
        var isValid = true
        if nameTextField.text == "" {
            nameMessageLabel.hidden = false
            isValid = false
        }
        if mobileNumberTextField.isValidNumber == false {
            mobileNumberMessageNumber.hidden = false
            isValid = false
        }
        if passwordTextField.text == "" || InformationValidator.isValidPassword(passwordTextField.text!) == false {
            passwordMessageLabel.hidden = false
            isValid = false
        }
        if InformationValidator.isValidEmail(emailTextField.text!) == false {
            emailMesageLabel.hidden = false
        }
        return isValid
    }
    
    func checkInput(completion: (isValid: Bool) -> Void) {
        var isValid = true
        removeAllMessageLabel()
        isValid = checkIfEmptyInput()
        if emailTextField.text == "" {
            emailMesageLabel.hidden = false
            isValid = false
            isValid = checkIfEmptyInput()
        }
        else {
            print (InformationValidator.isValidEmail(emailTextField.text!))
            if InformationValidator.isValidEmail(emailTextField.text!) {
                FIRAuth.auth()?.fetchProvidersForEmail(emailTextField.text!, completion: { (email:[String]?,error: NSError?) in
                    if email != nil {
                        isValid = self.checkIfEmptyInput()
                        self.emailMesageLabel.hidden = false
                        isValid = false
                        
                    }
                    else {
                        
                        
                    }
                    completion(isValid: isValid)
                })
            }
            else {
                isValid = self.checkIfEmptyInput()
            }
        }
        
        
    }
    
    func getPhoneCountryCode()-> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        // Get carrier name
        let countryCode = carrier?.isoCountryCode
        if countryCode != nil {
            return CountryCode.getCountryPhonceCode((countryCode?.uppercaseString)!)
        }
        return ""
    }
    
    @IBAction func onBeginEditing(sender: UITextField) {
        sender.placeholder = ""
        if sender == nameTextField {
            nameLabel.hidden = false
        }
        else if sender == emailTextField {
            emailLabel.hidden = false
        }
        else if sender == mobileNumberTextField{
            mobileNumberLabel.hidden = false
        }
        else if sender == passwordTextField {
            passwordLabel.hidden = false
        }
        
        
    }
    
    @IBAction func onEndEditing(sender: UITextField) {
        if sender.text == "" {
            if sender == nameTextField {
                nameLabel.hidden = true
                sender.placeholder = "Your Name"
            }
            else if sender == emailTextField {
                emailLabel.hidden = true
                sender.placeholder = "Email Address"
            }
            else if sender == mobileNumberTextField{
                mobileNumberLabel.hidden = true
                sender.placeholder = "Mobile Number"
            }
            if sender == passwordTextField {
                passwordLabel.hidden = true
                sender.placeholder = "Password"
            }
            
        }
    }
    
  
    @IBAction func onRegister(sender: AnyObject) {
        checkInput { (isValid) in
            if isValid {
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AuthenticationViewController") as! AuthenticationViewController
                controller.email = self.emailTextField.text!
                controller.phoneNumber = self.mobileNumberTextField.text!
                controller.name = self.nameTextField.text!
                controller.password = self.passwordTextField.text!
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        
        
        
    }
    
}

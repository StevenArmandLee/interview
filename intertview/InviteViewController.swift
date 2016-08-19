//
//  InviteViewController.swift
//  intertview
//
//  Created by steven lee on 19/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import MessageUI
import AddressBook
import AddressBookUI
import Contacts
import ContactsUI
import PhoneNumberKit

class InviteViewController: UIViewController, MFMessageComposeViewControllerDelegate, CNContactPickerDelegate, UITextFieldDelegate {

    let phoneNumberKit = PhoneNumberKit()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.removeBorder()
        phoneNumberTextField.removeBorder()
        phoneNumberTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersInString:"+0123456789").invertedSet
        
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
    
    @IBAction func onInvite(sender: AnyObject) {
        print(phoneNumberTextField.isValidNumber)
        if(MFMessageComposeViewController.canSendText()){
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Hi " + nameTextField.text! + ", I would like you to join me on Connected Life! Please download the CoLife app and accept my invitation: url"
            messageVC.recipients = [phoneNumberTextField.text!]
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        
        
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: { 
                
            })
        case MessageComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: {
                
            })
        case MessageComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: {
                
            })
        default:
            break;
        }
    }
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        print(contact.givenName)
        print((contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as! String)
    }
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        
    }
    
    @IBAction func onSearchContact(sender: AnyObject) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.view.backgroundColor = UIColor.blackColor()
        contactPicker.delegate = self
        
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

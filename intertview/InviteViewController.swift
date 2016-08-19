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

class InviteViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func onInvite(sender: AnyObject) {
        
        if(MFMessageComposeViewController.canSendText()){
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Hi " + nameTextField.text! + ", I would like you to join me on Connected Life! Please download the CoLife app and accept my invitation: url"
            messageVC.recipients = [phoneTextField.text!]
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
    
    
    @IBAction func onSearchContact(sender: AnyObject) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(.Contacts)
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            print("Denied")
            break
        case .Authorized:
            print("Authorized")
            break
        case .NotDetermined:
            print("not determined")
            break
        default:
            break
        }
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

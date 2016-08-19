//
//  MainViewController.swift
//  intertview
//
//  Created by steven lee on 19/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth,user: FIRUser?) in
                    if user != nil {
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
                        controller.userID = (user?.uid)!
                        self.presentViewController(controller, animated: false, completion: nil)
                    }
                    else {
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginRegisterViewController") as! LoginRegisterViewController
                        self.presentViewController(controller, animated: false, completion: nil)
                    }
                })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

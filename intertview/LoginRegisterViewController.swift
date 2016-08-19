//
//  ViewController.swift
//  intertview
//
//  Created by steven lee on 15/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var loginOrRegisterSegment: UISegmentedControl!
    @IBOutlet weak var registerContainerView: UIView!
    @IBOutlet weak var loginContainerView: UIView!
    override func viewDidLoad() {
        registerContainerView.hidden = true
        super.viewDidLoad()
        loginOrRegisterSegment.removeBorders()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth,user: FIRUser?) in
//            if user != nil {
//                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
//                controller.userID = user!.uid
//                self.presentViewController(controller, animated: true, completion: nil)
//            }
//        })
    }

    @IBAction func onRegisterOrLoginSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            registerContainerView.hidden = true
            loginContainerView.hidden = false
        }
        else {
            registerContainerView.hidden = false
            loginContainerView.hidden = true
        }
    }

}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(UIColor.darkGrayColor()), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor.darkGrayColor()), forState: .Selected, barMetrics: .Default)
        setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: .Selected)
        setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState: .Normal)
        setDividerImage(imageWithColor(UIColor.clearColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}
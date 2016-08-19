//
//  ProfileViewController.swift
//  intertview
//
//  Created by steven lee on 17/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var userID = ""
    let rootRef = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
            //self.getData()
        let databaseModel = DatabaseModel()
        databaseModel.getDataFromDatabase(self.userID, complition: { (userInformation, error) in
            let userInformations = userInformation
            self.nameLabel.text = userInformations["Name"]
            self.emailLabel.text = userInformations["Email"]
            self.phoneNumberLabel.text = userInformations["Phone"]
            self.putPhotoToUI(self.downloadImage(NSURL(string: userInformations["Picture"]!)!))
        })

        
    }
    
    func getData() {
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth,user: FIRUser?) in
            self.rootRef.child(self.userID).observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
                if let dict = snapshot.value as? Dictionary<String,String> {
                    self.nameLabel.text = dict["Name"]
                    self.emailLabel.text = dict["Email"]
                    self.phoneNumberLabel.text = dict["Phone"]
                    self.putPhotoToUI(self.downloadImage(NSURL(string: dict["Picture"]!)!))
                    
                }
            })

            
//            var handle = self.rootRef.child((user?.uid)!).observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
//                if let dict = snapshot.value as? Dictionary<String,String> {
//                    self.nameLabel.text = dict["Name"]
//                    self.emailLabel.text = dict["Email"]
//                    self.phoneNumberLabel.text = dict["Phone"]
//                    self.putPhotoToUI(self.downloadImage(NSURL(string: dict["Picture"]!)!))
//                    
//                }}
//            self.rootRef.removeObserverWithHandle(handle)
//            print("aaa")
//            databaseModel.getDataFromDatabase((user?.uid)!, complition: { (userInformation, error) in
//                let userInformations = userInformation
//                self.nameLabel.text = userInformations["Name"]
//                self.emailLabel.text = userInformations["Email"]
//                self.phoneNumberLabel.text = userInformations["Phone"]
//                self.putPhotoToUI(self.downloadImage(NSURL(string: userInformations["Picture"]!)!))
//            })
        })
    }
    func putPhotoToUI(image: UIImage) {
        let scale = 150/image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(150, newHeight))
        image.drawInRect(CGRectMake(0, 0, 150, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let faceImageView = UIImageView(image: newImage)
        faceImageView.contentMode = UIViewContentMode.ScaleAspectFill
        WikiFace.centerImageViewOnFace(faceImageView)
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIGraphicsBeginImageContextWithOptions(faceImageView.bounds.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
            faceImageView.layer.renderInContext(context!)
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageData = UIImageJPEGRepresentation(croppedImage, 1)
            self.profilePicture.image = UIImage(data: imageData!)
            self.profilePicture.layer.borderWidth = 1
            self.profilePicture.layer.masksToBounds = false
            self.profilePicture.layer.borderColor = UIColor.blackColor().CGColor
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height/2
            self.profilePicture.clipsToBounds = true
            })
        
    }
    func downloadImage(url: NSURL) -> UIImage {
        var image = UIImage()
        if let data = NSData(contentsOfURL: url) {
            image = UIImage(data: data)!
        }
        return image
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        do {
            try! FIRAuth.auth()?.signOut()
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginRegisterViewController") as! LoginRegisterViewController
            self.presentViewController(controller, animated: false, completion: nil)
        } catch let error {
            print (error)
        }
    }
    
}

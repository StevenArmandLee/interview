//
//  uploadPictureViewContoller.swift
//  intertview
//
//  Created by steven lee on 17/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class UploadPictureViewContoller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userID = ""
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBAction func onUpdatePhoto(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: "Camera", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    func showCamera(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate=self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
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
            
            let databaseModel = DatabaseModel()
            
            //upload the image to the database as soon as the image is put to the UI
            //TODO change to the real information
            databaseModel.getDataFromDatabase(self.userID, complition: { (userInformation, error) in
                databaseModel.sendPicture(image, email: userInformation["Email"]!, name: userInformation["Name"]!, phone: userInformation["Phone"]!, userID: self.userID)
                self.nextButton.enabled = true
            })
        })

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        putPhotoToUI(image)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func showAlbum(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate=self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }

}

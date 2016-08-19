//
//  DatabaseModel.swift
//  intertview
//
//  Created by steven lee on 17/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit
class DatabaseModel {
    let rootRef = FIRDatabase.database().reference()
    
    func sendToDatabase(email: String, name: String, phone: String, picture: String, userID: String) {
        let userData = ["Email": email, "Name": name, "Phone": phone, "Picture": picture]
        rootRef.child(userID).setValue(userData)
    }
    func getDataFromDatabase(userID: String, complition: (userInformation: Dictionary<String,String>!, error:NSError?)->()) {
        
        rootRef.child(userID).observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? Dictionary<String,String> {
                complition(userInformation: dict,error: nil)
            }
        }
    }
    
    func sendPicture(picture: UIImage, email: String, name: String, phone: String, userID: String) {
        let data = UIImageJPEGRepresentation(picture, 0.1)
        let metadata = FIRStorageMetadata()
        var photoUrl = ""
        metadata.contentType = "image/jpg"
        FIRStorage.storage().reference().child(userID).putData(data!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            photoUrl = metadata!.downloadURLs![0].absoluteString
            let databaseModel = DatabaseModel()
            databaseModel.sendToDatabase(email, name: name, phone: phone, picture: photoUrl, userID: userID)
        }
        
    }
}
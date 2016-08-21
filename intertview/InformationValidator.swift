//
//  InformationValidator.swift
//  intertview
//
//  Created by steven lee on 21/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import Foundation
class InformationValidator: NSObject {
    
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    class func isValidPassword(candidate: String) -> Bool {
        let passwordRegex = "(?=.*[a-z])(.*[A-Z])(.*\\d).{6,15}"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluateWithObject(candidate)
    }
    
}
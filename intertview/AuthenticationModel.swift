//
//  authenticationModel.swift
//  intertview
//
//  Created by steven lee on 16/8/16.
//  Copyright © 2016 steven lee. All rights reserved.
//

import Foundation

class AuthenticationModel {
    var token: UInt32 = 0
    func sendSMS(phoneNumber: String){
        token = arc4random_uniform(8999) + 1000
        let twilioSID = "AC674cd18bc56c46fa43caefe57a145150"
        let twilioSecret = "0effb1cf5e577b37fefe02c25af431b9"
        
        //Note replace + = %2B , for To and From phone number
        let fromNumber = "%2B13158832810"// actual number is +14803606445
        let toNumber = "%2B"+phoneNumber.stringByReplacingOccurrencesOfString("+", withString: "")// actual number is +919152346132
        let message = "Your verification code is \(token) for signup with Interview App "
        
        // Build the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
}
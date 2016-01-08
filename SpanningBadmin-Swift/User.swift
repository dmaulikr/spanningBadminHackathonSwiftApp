//
//  User.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import Foundation

/**
 * User Model
 *
 * @author Greg Alexander
 * @version 1.0
 */
class User: NSObject {
    var name: String
    var email: String
    var idToken: String // Safe to send to the server
    var userId: String // For client-side use only!
    
    init(name: String, email: String, idToken: String, userId: String) {
        self.name = name
        self.email = email
        self.idToken = idToken
        self.userId = userId
    }
    
    /*
     * Function to to see if user is super user
     * @return bool
     */
    func isSuperUser() -> Bool {
        return AuthUtils.sharedInstance.isSuperUser(self.email)
    }
    
    /*
     * Function to to see if user is prod user
     * @return bool
     */
    func isProdUser() -> Bool {
        return AuthUtils.sharedInstance.isProdUser(self.email)
    }
}

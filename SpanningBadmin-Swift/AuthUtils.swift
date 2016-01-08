//
//  AuthUtils.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import Foundation

/**
 * AuthUtils
 * A Singleton for managing all things related to authentication
 *
 * @author Greg Alexander
 * @version 1.0
 */
class AuthUtils {
    let SUPER_USERS: [String] = [
        "mpav@spanning.com",
        "byron.shaheen@spanning.com",
        "clif@spanning.com",
        "andrea.adams@spanning.com",
        "taylor.patterson@spanning.com",
        "brandon.mayes@spanning.com",
        "ruel.loehr@spanning.com",
        "jonathan.lindstrom@spanning.com",
        "jacob.holt@spanning.com",
        "travis.wood@spanning.com"
    ]
    
    let PROD_USERS: [String] = [
        "pcifra@spanning.com",
        "joel.rosinbum@spanning.com",
        "greg.alexander@spanning.com"
    ]
    
    static let sharedInstance = AuthUtils()
    var currentUser: User?
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    /*
     * Function to clear the current user
     */
    func clearUser() {
        self.currentUser = nil
    }
    
    /*
     * Function to get domain from email address
     * @param {String} email - email to check
     * @return {String} domain
     */
    func getDomainFromEmail(email: String) -> String {
        var emailParts = email.componentsSeparatedByString("@")
        
        if (emailParts.count == 2) {
            return emailParts[1]
        } else {
            return ""
        }
        
    }
    
    /* 
     * Function to determine if the user is a valid spanning user
     * @param {String} email - email to check
     * @return {Boolean}
     */
    func isSpanningUser(email: String) -> Bool {
        if ((email ?? "").isEmpty) {
            return false;
        }
        
        return getDomainFromEmail(email).lowercaseString == "spanning.com"
    }
    
    /*
     * Function to return true if the email address is from the spanning.com domain and is found in the SUPER_USERS list, false otherwise.
     * @param {String} email - An email address.
     * @return {Boolean} - True if the email address is a spanning.com email address and is found in the SUPER_USERS list.
     */
    func isSuperUser(email: String) -> Bool {
        return isSpanningUser(email) && SUPER_USERS.contains(email)
    };
    
    /*
     * Function to return  true if the email address is from the spanning.com domain and is found in the PROD_SUPPORT_USERS list, false otherwise.
     * @param {String} email - An email address.
     * @returns {Boolean} - True if the email address is a spanning.com email address and is found in the SUPER_USERS list.
     */
    func isProdUser(email: String) -> Bool {
        return isSpanningUser(email) && PROD_USERS.contains(email);
    };
}
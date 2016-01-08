//
//  HTTPUtils.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 * HTTPUtils
 * A Singleton for managing all things related to http requests
 *
 * @author Greg Alexander
 * @version 1.0
 */
class HTTPUtils {
    // Singleton Instance
    static let sharedInstance = HTTPUtils()
    
    let requestProtocol: String = "https://"
    let host: String = "localhost:8000"
    let apiRoot: String = "/api-int"
    
    // Need to do this to allow unsecure requests to localhost. Pain in the ass :(
    var Manager : Alamofire.Manager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost": .DisableEvaluation
        ]
        
        // Create custom manager
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        configuration.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        let man = Alamofire.Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return man
    }()
    
    private init() {}
    
    /*
     * Function to get cookies for user to set them
     */
    func authUser(idToken: String, callback:(Response<AnyObject, NSError>) -> ()) {
        let urlString: String = "\(requestProtocol)\(host)\(apiRoot)/mobileauth"
        let parameters = [
            "id_token": idToken
        ]
        
        Manager.request(.POST, urlString, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
                callback(response)
            }
    }
    
    /*
     * Function to get all orgs from server
     */
    func getAllOrgs(callback: (JSON, Response<AnyObject, NSError>) -> ()) {
        let urlString: String = "\(requestProtocol)\(host)\(apiRoot)/orgs"
        
        Manager.request(.GET, urlString)
            .responseJSON { response in
                var json: JSON = nil
                print("Response JSON: \(response.result.value)")
                
                if let object: AnyObject = response.result.value {
                    json = JSON(object)
                }
                
                callback(json, response)
            }
    }
}
//
//  AppDelegate.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize google sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        // make sure there are no config errors
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
            sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey]! as! String,
            annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    // For iOS 8 and older
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
            UIApplicationOpenURLOptionsAnnotationKey: annotation]
        return self.application(application,
            openURL: url,
            options: options)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    // GIDSignInDelegate protocol functions below
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  
            let idToken = user.authentication.idToken
            let name = user.profile.name
            let email = user.profile.email
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            if (AuthUtils.sharedInstance.isSpanningUser(email)) {
                let loggedInUser = User(name: name, email: email, idToken: idToken, userId: userId)
                AuthUtils.sharedInstance.currentUser = loggedInUser
                
                // auth the user with server
                HTTPUtils.sharedInstance.authUser(AuthUtils.sharedInstance.currentUser!.idToken) { res in
                    if (res.response?.statusCode == 200) {
                        // Get and go to main view
                        let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("SBMainViewController")
                        self.window?.rootViewController?.showViewController(mainVC, sender: self.window?.rootViewController)
                    } else {
                        let deniedVC = mainStoryboard.instantiateViewControllerWithIdentifier("SBAccessDeniedViewController")
                        self.window?.rootViewController?.presentViewController(deniedVC, animated: true, completion: nil)
                    }
                }
            } else {
                let deniedVC = mainStoryboard.instantiateViewControllerWithIdentifier("SBAccessDeniedViewController")
                self.window?.rootViewController?.presentViewController(deniedVC, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Log in error", message: "An error occured while logging in", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        GIDSignIn.sharedInstance().signOut()
    }
}


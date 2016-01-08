//
//  SBAccessDeniedViewController.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import UIKit

class SBAccessDeniedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AuthUtils.sharedInstance.clearUser()
        // log user out
        GIDSignIn.sharedInstance().signOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

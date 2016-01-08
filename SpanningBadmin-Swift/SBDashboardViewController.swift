//
//  SBDashboardViewController.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import UIKit

class SBDashboardViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var activeOrgLabel: UILabel!
    @IBOutlet weak var totalOrgLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        getDashboardData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDashboardData() {
        HTTPUtils.sharedInstance.getAllOrgs() { (responseObj, res) in
            if (res.response?.statusCode == 200 && responseObj != nil) {
                let orgs = responseObj.array
                let orgsCount = responseObj.count
                var activeOrgs: Int = 0
                
                for org in orgs! {
                    if let orgData = org.dictionary {
                        for dataItem in orgData {
                            // dataItem is Tuple
                            if (dataItem.0 == "active" && dataItem.1.intValue == 1) {
                                activeOrgs++
                            }
                        }
                    }
                }
                
                self.totalOrgLabel.text = "\(orgsCount)"
                self.activeOrgLabel.text = "\(activeOrgs)"
                
            } else {
                let alertController = UIAlertController(title: "Error Getting Data", message:"Error", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

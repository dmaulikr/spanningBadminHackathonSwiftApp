//
//  SBOrgsViewController.swift
//  SpanningBadmin-Swift
//
//  Created by Alexander, Gregory on 1/6/16.
//  Copyright © 2016 Alexander, Gregory. All rights reserved.
//

import UIKit

class SBOrgsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orgsArray: [Org] = []

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // get rid of empty table cells
        tableView.tableFooterView = UIView()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        getOrgs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orgsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.orgsArray[indexPath.row].name
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "Org Selected", message: "You selected \(self.orgsArray[indexPath.row].name!) with sfid \(self.orgsArray[indexPath.row].sfId!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (self.orgsArray[indexPath.row].active == false)
        {
            cell.backgroundColor = UIColor.redColor()
        }
        else
        {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
    }
    
    func getOrgs() {
        HTTPUtils.sharedInstance.getAllOrgs() { (responseObj, res) in
            if (res.response?.statusCode == 200 && responseObj != nil) {
                let orgs = responseObj.array
                for org in orgs! {
                    let orgObj = Org()
                    if let orgData = org.dictionary {
                        for dataItem in orgData {
                            // dataItem is Tuple
                            if (dataItem.0 == "active") {
                                orgObj.active = dataItem.1.boolValue
                            } else if (dataItem.0 == "id") {
                                orgObj.id = dataItem.1.intValue
                            } else if (dataItem.0 == "name") {
                                orgObj.name = dataItem.1.stringValue
                            } else if (dataItem.0 == "sfId") {
                                orgObj.sfId = dataItem.1.stringValue
                            }
                        }
                    }
                    self.orgsArray.append(orgObj)
                }
                
                // reload table
                self.tableView?.reloadData()
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

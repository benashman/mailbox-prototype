//
//  LaterMenuViewController.swift
//  mailbox-prototype
//
//  Created by Ben Ashman on 11/8/15.
//  Copyright © 2015 Ben Ashman. All rights reserved.
//

import UIKit

class LaterMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scheduleForLaterToday(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("Later Today", object: nil)
    }
}

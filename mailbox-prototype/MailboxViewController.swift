//
//  MailboxViewController.swift
//  mailbox-prototype
//
//  Created by Ben Ashman on 11/3/15.
//  Copyright © 2015 Ben Ashman. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var message: UIImageView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var leftMenuIcon: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageParentView.backgroundColor = UIColor.grayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeMessage(sender: AnyObject) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        if sender.state == .Began {
            messageOriginalCenter = message.center
        } else if sender.state == .Changed {
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            print("translation: \(translation.x)")
            
            switch translation.x {

            // Archive
            case 60...220:
                messageParentView.backgroundColor = UIColor.greenColor()
                leftMenuIcon.image = UIImage(named: "archive_icon")
                
            // Delete
            case 220...screenWidth:
                self.messageParentView.backgroundColor = UIColor.redColor()
                leftMenuIcon.image = UIImage(named: "delete_icon")
                
            // Reschedule
            case -220...(-60):
                self.messageParentView.backgroundColor = UIColor.yellowColor()
                
            // Later
            case -screenWidth...(-220):
                self.messageParentView.backgroundColor = UIColor.brownColor()
                
            default:
                return
            }
            
        } else if sender.state == .Ended {
            print("pan ended")
            
            self.messageParentView.backgroundColor = UIColor.grayColor()

            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                self.message.center = self.messageOriginalCenter
                }, completion: { (finished: Bool) -> Void in
                    self.resetActionStates()
            })
        }
    }
    
    func resetActionStates() {
        leftMenuIcon.image = UIImage(named: "archive_icon")
    }
}

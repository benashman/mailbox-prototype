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
    @IBOutlet weak var rightMenuIcon: UIImageView!
    
    var defaultColor = UIColor(red: 0.889, green: 0.889, blue: 0.889, alpha: 1.0)
    var archiveColor = UIColor(red: 0.361, green: 0.859, blue: 0.39, alpha: 1.0)
    var deleteColor  = UIColor(red: 0.943, green: 0.337, blue: 0.0, alpha: 1.0)
    var laterColor   = UIColor(red: 0.999, green: 0.838, blue: 0.0, alpha: 1.0)
    var listColor    = UIColor(red: 0.847, green: 0.656, blue: 0.45, alpha: 1.0)
    
    var messageOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageParentView.backgroundColor = defaultColor
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
                messageParentView.backgroundColor = archiveColor
                leftMenuIcon.image = UIImage(named: "archive_icon")
                
            // Delete
            case 220...screenWidth:
                self.messageParentView.backgroundColor = deleteColor
                leftMenuIcon.image = UIImage(named: "delete_icon")
                
            // Reschedule
            case -220...(-60):
                self.messageParentView.backgroundColor = laterColor
                rightMenuIcon.image = UIImage(named: "later_icon")
                
            // Later
            case -screenWidth...(-220):
                self.messageParentView.backgroundColor = listColor
                rightMenuIcon.image = UIImage(named: "list_icon")
                
            default:
                return
            }
            
        } else if sender.state == .Ended {
            print("pan ended")
            
            self.messageParentView.backgroundColor = defaultColor

            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                self.message.center = self.messageOriginalCenter
                }, completion: { (finished: Bool) -> Void in
                    self.resetActionStates()
            })
        }
    }
    
    func resetActionStates() {
        leftMenuIcon.image = UIImage(named: "archive_icon")
        rightMenuIcon.image = UIImage(named: "later_icon")
    }
}

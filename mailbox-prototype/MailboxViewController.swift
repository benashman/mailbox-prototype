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
    @IBOutlet weak var inbox: UIImageView!
    
    var defaultColor = UIColor(red: 0.889, green: 0.889, blue: 0.889, alpha: 1.0)
    var archiveColor = UIColor(red: 0.361, green: 0.859, blue: 0.39, alpha: 1.0)
    var deleteColor  = UIColor(red: 0.943, green: 0.337, blue: 0.0, alpha: 1.0)
    var laterColor   = UIColor(red: 0.999, green: 0.838, blue: 0.0, alpha: 1.0)
    var listColor    = UIColor(red: 0.847, green: 0.656, blue: 0.45, alpha: 1.0)
    
    var messageOriginalCenter: CGPoint!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    var action = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set deafult states
        messageParentView.backgroundColor = defaultColor
        leftMenuIcon.alpha = 0.0
        rightMenuIcon.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeMessage(sender: AnyObject) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            messageOriginalCenter = message.center
        } else if sender.state == .Changed {
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
//            print("translation: \(translation.x)")
            
            switch translation.x {
                
            // Swipe Right
            case 0...60:
                leftMenuIcon.alpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0.2, r2Max: 1)
                action = "none"
            case 60...220:
                messageParentView.backgroundColor = archiveColor
                leftMenuIcon.image = UIImage(named: "archive_icon")
                leftMenuIcon.transform = CGAffineTransformMakeTranslation(message.frame.origin.x - 60, 0)
                action = "archive"
            case 220...screenWidth:
                self.messageParentView.backgroundColor = deleteColor
                leftMenuIcon.image = UIImage(named: "delete_icon")
                leftMenuIcon.transform = CGAffineTransformMakeTranslation(message.frame.origin.x - 60, 0)
                action = "delete"
                
            // Swipe Left
            case -60...(-0.1):
                rightMenuIcon.alpha = convertValue(translation.x, r1Min: -0.5, r1Max: -60, r2Min: 0.2, r2Max: 1)
                action = "none"
            case -220...(-60):
                self.messageParentView.backgroundColor = laterColor
                rightMenuIcon.image = UIImage(named: "later_icon")
                rightMenuIcon.transform = CGAffineTransformMakeTranslation(message.frame.origin.x + 60, 0)
                action = "later"
            case -screenWidth...(-220):
                self.messageParentView.backgroundColor = listColor
                rightMenuIcon.image = UIImage(named: "list_icon")
                rightMenuIcon.transform = CGAffineTransformMakeTranslation(message.frame.origin.x + 60, 0)
                action = "list"
            default:
                return
            }
            
        } else if sender.state == .Ended {
            print("selected action: \(action)")
            
            switch action {
            case "none":
                self.messageParentView.backgroundColor = defaultColor
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                    self.message.center = self.messageOriginalCenter
                    }, completion: { (finished: Bool) -> Void in
                        self.resetActionStates()
                })
            case "delete":
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                    self.message.frame.origin.x = self.screenWidth + 100
                    self.leftMenuIcon.transform = CGAffineTransformMakeTranslation(self.message.frame.origin.x - 60, 0)
                    }, completion: { (finished: Bool) -> Void in
                        self.resetActionStates()
                        
                        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
                            self.inbox.transform = CGAffineTransformMakeTranslation(0, -self.message.frame.size.height)
                        }, completion: nil)
                    }
                )
            case "later":
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                    self.message.frame.origin.x = -self.screenWidth - 100
                    self.rightMenuIcon.transform = CGAffineTransformMakeTranslation(self.message.frame.origin.x + 60, 0)
                    }, completion: { (finished: Bool) -> Void in
                        self.resetActionStates()
                })
            default:
                return
            }
        }
    }
    
    func resetActionStates() {
        leftMenuIcon.alpha = 0
        leftMenuIcon.image = UIImage(named: "archive_icon")
        leftMenuIcon.transform = CGAffineTransformIdentity
        
        rightMenuIcon.alpha = 0
        rightMenuIcon.image = UIImage(named: "later_icon")
        rightMenuIcon.transform = CGAffineTransformIdentity
    }
}

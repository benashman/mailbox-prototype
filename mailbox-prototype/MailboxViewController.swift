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
    
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var inbox: UIImageView!

    var sidebarColor = UIColor(red: 0.269, green: 0.269, blue: 0.269, alpha: 1.0)
    var defaultColor = UIColor(red: 0.889, green: 0.889, blue: 0.889, alpha: 1.0)
    var archiveColor = UIColor(red: 0.361, green: 0.859, blue: 0.39,  alpha: 1.0)
    var deleteColor  = UIColor(red: 0.943, green: 0.337, blue: 0.0,   alpha: 1.0)
    var laterColor   = UIColor(red: 0.999, green: 0.838, blue: 0.0,   alpha: 1.0)
    var listColor    = UIColor(red: 0.847, green: 0.656, blue: 0.45,  alpha: 1.0)
    
    var messageOriginalCenter: CGPoint!
    var inboxViewOriginalCenter: CGPoint!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    var action = "none"
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        
        // Set deafult states
        sidebarView.backgroundColor = sidebarColor
        messageParentView.backgroundColor = defaultColor
        leftMenuIcon.alpha = 0.0
        rightMenuIcon.alpha = 0.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scheduleForLaterToday", name: "Later Today", object: nil)
        
        // Add sidebar swipe gesture recognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        inboxView.addGestureRecognizer(edgeGesture)
    }
    
    @IBAction func swipeMessage(sender: AnyObject) {
        let translation = sender.translationInView(view)
        
        if sender.state == .Began {
            messageOriginalCenter = message.center
        } else if sender.state == .Changed {
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
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
            case "archive", "delete":
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                    self.message.frame.origin.x = self.screenWidth + 100
                    self.leftMenuIcon.transform = CGAffineTransformMakeTranslation(self.message.frame.origin.x - 60, 0)
                    }, completion: { (finished: Bool) -> Void in
                        self.resetActionStates()
                        self.refreshInbox()
                    }
                )
            case "later", "list":
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                    self.message.frame.origin.x = -self.screenWidth - 100
                    self.rightMenuIcon.transform = CGAffineTransformMakeTranslation(self.message.frame.origin.x + 60, 0)
                    }, completion: { (finished: Bool) -> Void in
                        self.resetActionStates()
                        self.performSegueWithIdentifier("laterMenu", sender: self)
                })
            default:
                return
            }
        }
    }
    
    
    @IBAction func closeSidebarMenu(sender: AnyObject) {
        print("close")
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
                self.inboxView.frame.origin.x = 0
            }, completion: nil
        )
    }
    
    func scheduleForLaterToday() {
        delay(0.25) {
            self.refreshInbox()
        }
    }
    
    func refreshInbox() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.inbox.transform = CGAffineTransformMakeTranslation(0, -self.message.frame.size.height)
        }, completion: nil)
    }
    
    func resetActionStates() {
        leftMenuIcon.alpha = 0
        leftMenuIcon.image = UIImage(named: "archive_icon")
        leftMenuIcon.transform = CGAffineTransformIdentity
        
        rightMenuIcon.alpha = 0
        rightMenuIcon.image = UIImage(named: "later_icon")
        rightMenuIcon.transform = CGAffineTransformIdentity
    }
    
    func undoLastAction() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
                self.inbox.transform = CGAffineTransformIdentity
                self.messageParentView.transform = CGAffineTransformIdentity
            }, completion: nil
        )
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            let alertController = UIAlertController(title: "Undo last action?", message: "Are you sure you want to undo and move 1 item back to Inbox?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Undo", style: .Default) { (action) in
                self.message.frame.origin = CGPoint(x: 0, y: 0)
                self.messageParentView.transform = CGAffineTransformMakeTranslation(0, -self.messageParentView.frame.size.height)
                self.undoLastAction()
            }
            
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: {})
        }
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            inboxViewOriginalCenter = inboxView.center
        } else if sender.state == .Changed {
            inboxView.center = CGPoint(x: inboxViewOriginalCenter.x + translation.x, y: inboxViewOriginalCenter.y)
        } else if sender.state == .Ended {
            if velocity.x > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
                    self.inboxView.frame.origin.x = 318
                    }, completion: nil
                )
            }
        }
    }
}










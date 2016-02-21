//
//  ViewController.swift
//  CodePath-wk3-Mailbox
//
//  Created by Yinan iMac on 2/20/16.
//  Copyright © 2016 YinanLearningSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var helpImageView: UIImageView!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!

    var messageInitialX: CGFloat!
    
    let mailboxGrey = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1)
    let mailboxBlue = UIColor(red: 123/255, green: 195/255, blue: 221/255, alpha: 1)
    let mailboxRed = UIColor(red: 218/255, green: 94/255, blue: 64/255, alpha: 1)
    let mailboxGreen = UIColor(red: 138/255, green: 212/255, blue: 113/255, alpha: 1)
    let mailboxYellow = UIColor(red: 244/255, green: 210/255, blue: 86/255, alpha: 1)
    let mailboxBrown = UIColor(red: 208/255, green: 167/255, blue: 124/255, alpha: 1)
    
    let swipeAnimationDuration = 0.4
    let hideAnimationDuration = 0.35
    let overlayAnimationDuration = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize.height = feedImageView.image!.size.height + searchImageView.image!.size.height + helpImageView.image!.size.height + messageView.bounds.height
        
        messageInitialX = messageImageView.center.x
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // http://courses.codepath.com/courses/ios_for_designers/pages/using_gesture_recognizers#heading-common-properties-to-access-from-each-gesture-recognizer
    @IBAction func messageViewPanGesture(sender: UIPanGestureRecognizer) {
        
        let iconDistanceFromEdge = CGFloat(40)
        let iconDistanceFromMessageImageCenter = CGFloat(180)
        let iconDistanceFromMessageImageEdgePlusIconWidth = CGFloat(45)
        
        let iconAlpha0FromEdge = CGFloat(30)
        let iconAlpha1FromEdge = CGFloat(65)
        
        let bounceBackX = CGFloat(60)
        let swipeLevelBreakpointX = CGFloat(260)
        
        let messageLocation = sender.locationInView(view)
        let messageTranslation = sender.translationInView(view)
        NSLog("messageView is panned this much \(messageTranslation) to this location \(messageLocation)")
        
//        var messageInitialX: CGFloat!
        
        if sender.state == UIGestureRecognizerState.Began {
//            messageInitialX = messageImageView.center.x
            messageView.backgroundColor = mailboxGrey
            deleteIcon.alpha = 0
            listIcon.alpha = 0
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            messageImageView.center.x = messageInitialX + messageTranslation.x
            
            // As the icon is revealed, it should start semi-transparent and become fully opaque.
            let alphaBasedOnPanForArchiveIcon = convertValue(messageImageView.center.x, r1Min: messageInitialX + iconAlpha0FromEdge, r1Max: messageInitialX + iconAlpha1FromEdge , r2Min: 0, r2Max: 1)
            let alphaBasedOnPanForLaterIcon = convertValue(messageImageView.center.x, r1Min: messageInitialX - iconAlpha0FromEdge, r1Max: messageInitialX - iconAlpha1FromEdge, r2Min: 0, r2Max: 1)
            archiveIcon.alpha = alphaBasedOnPanForArchiveIcon
            laterIcon.alpha = alphaBasedOnPanForLaterIcon
            
            
            // After bounceBackX, the action icon should start moving with the translation and the background should change to the short swipe action colors corresponding to left and right swipe. After swipeLevelBreakpointX, the icons and background colors should change to the long swipe ones. All ifs below:
            
            if messageImageView.center.x > messageInitialX + bounceBackX && messageImageView.center.x <= messageInitialX + swipeLevelBreakpointX{
                // left bg revealed beyond bounceBackX && within swipeLevelBreakpointX
                deleteIcon.alpha = 0
                archiveIcon.center.x = messageImageView.center.x - iconDistanceFromMessageImageCenter
                messageView.backgroundColor = mailboxGreen
                
            } else if messageImageView.center.x > messageInitialX && messageImageView.center.x <= messageInitialX + bounceBackX {
                // left bg revealed within bounceBackX
                archiveIcon.center.x = iconDistanceFromEdge
                messageView.backgroundColor = mailboxGrey
                
            } else if messageImageView.center.x > messageInitialX + swipeLevelBreakpointX {
                // left bg revealed beyond swipeLevelBreakpointX
                messageView.backgroundColor = mailboxRed
                deleteIcon.center.x = messageImageView.center.x - iconDistanceFromMessageImageCenter
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
            
            } else if messageImageView.center.x < messageInitialX - bounceBackX && messageImageView.center.x >= messageInitialX - swipeLevelBreakpointX {
                // right bg revealed beyond bounceBackX && within swipeLevelBreakpointX
                listIcon.alpha = 0
                laterIcon.center.x = messageImageView.center.x + iconDistanceFromMessageImageCenter
                messageView.backgroundColor = mailboxYellow
            
            } else if messageImageView.center.x >= messageInitialX - bounceBackX && messageImageView.center.x < messageInitialX {
                // right bg revealed within bounceBackX
                laterIcon.center.x = messageImageView.bounds.width - iconDistanceFromEdge
                messageView.backgroundColor = mailboxGrey
            
            } else if messageImageView.center.x < messageInitialX - swipeLevelBreakpointX {
                // right bg revealed beyond swipeLevelBreakpointX
                messageView.backgroundColor = mailboxBrown
                listIcon.center.x = messageImageView.center.x + iconDistanceFromMessageImageCenter
                laterIcon.alpha = 0
                listIcon.alpha = 1
        
            } else {
                // safe catch, there should be only unswipped position (messageImageView.center.x == messageInitialX) here.
                messageView.backgroundColor = mailboxGrey
            }
    
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if messageImageView.center.x < messageInitialX + bounceBackX && messageImageView.center.x > messageInitialX - bounceBackX {
                // If released within bounceBackX, the message should return to its initial position.
                messageImageView.center.x = messageInitialX
                
            } else if messageImageView.center.x < messageInitialX - bounceBackX && messageImageView.center.x >= messageInitialX - swipeLevelBreakpointX {
                // yellow/later
                // Upon release, the message should continue to reveal the yellow background. When the animation it complete, it should show the reschedule options.
                UIView.animateWithDuration(swipeAnimationDuration, animations: {
                    self.messageImageView.center.x = -self.messageImageView.bounds.width/2 - iconDistanceFromMessageImageEdgePlusIconWidth
                    self.laterIcon.center.x = self.messageImageView.center.x + iconDistanceFromMessageImageCenter
                })
                UIView.animateWithDuration(overlayAnimationDuration, delay: swipeAnimationDuration, options: [], animations: {
                    self.rescheduleImageView.alpha = 1
                }, completion: nil)
                
            } else if messageImageView.center.x < messageInitialX - swipeLevelBreakpointX {
                // brown/list
                // Upon release, the message should continue to reveal the red background. When the animation it complete, it should hide the message.
                UIView.animateWithDuration(swipeAnimationDuration, animations: {
                    self.messageImageView.center.x = -self.messageImageView.bounds.width/2 - iconDistanceFromMessageImageEdgePlusIconWidth
                    self.listIcon.center.x = self.messageImageView.center.x + iconDistanceFromMessageImageCenter
                })
                UIView.animateWithDuration(overlayAnimationDuration, delay: swipeAnimationDuration, options: [], animations: {
                    self.listImageView.alpha = 1
                    }, completion: nil)
                
            } else if messageImageView.center.x > messageInitialX + bounceBackX && messageImageView.center.x < messageInitialX + swipeLevelBreakpointX {
                // green/archive
                // Upon release, the message should continue to reveal the green background. When the animation it complete, it should hide the message.
                UIView.animateWithDuration(swipeAnimationDuration, animations: {
                    self.messageImageView.center.x = self.messageImageView.bounds.width * 1.5 + iconDistanceFromMessageImageEdgePlusIconWidth
                    self.archiveIcon.center.x = self.messageImageView.center.x - iconDistanceFromMessageImageCenter
                })
                UIView.animateWithDuration(hideAnimationDuration, delay: swipeAnimationDuration, options: [], animations: {
                    self.feedImageView.center.y -= self.messageView.bounds.height
                    }, completion: nil)
            } else if messageImageView.center.x > messageInitialX + swipeLevelBreakpointX {
                // red/delete
                // Upon release, the message should continue to reveal the red background. When the animation it complete, it should hide the message.
                UIView.animateWithDuration(swipeAnimationDuration, animations: {
                    self.messageImageView.center.x = self.messageImageView.bounds.width * 1.5 + iconDistanceFromMessageImageEdgePlusIconWidth
                    self.deleteIcon.center.x = self.messageImageView.center.x - iconDistanceFromMessageImageCenter
                })
                UIView.animateWithDuration(hideAnimationDuration, delay: swipeAnimationDuration, options: [], animations: {
                    self.feedImageView.center.y -= self.messageView.bounds.height
                    }, completion: nil)
            }
        }
    }
    
    // User can tap to dismissing the reschedule or list options. After the reschedule or list options are dismissed, you should see the message finish the hide animation.
    @IBAction func rescheduleImageTapGesture(sender: UITapGestureRecognizer) {
        rescheduleImageView.alpha = 0
        UIView.animateWithDuration(hideAnimationDuration, animations: {
            self.feedImageView.center.y -= self.messageView.bounds.height
        })
    }
    @IBAction func listImageTagGesture(sender: UITapGestureRecognizer) {
        listImageView.alpha = 0
        UIView.animateWithDuration(hideAnimationDuration, animations: {
            self.feedImageView.center.y -= self.messageView.bounds.height
        })
    }
    
    // undo fake hiding animation, with messageView back to original state
    @IBAction func feedImageTapGesture(sender: UITapGestureRecognizer) {
        messageView.backgroundColor = mailboxGrey
        messageImageView.center.x = messageInitialX
        UIView.animateWithDuration(hideAnimationDuration, animations: {
//            self.feedImageView.center.y += self.messageView.bounds.height
//            let toprint = self.feedImageView.center.y
//            print(toprint)
            self.feedImageView.center.y = 766
        })
    }
    
}


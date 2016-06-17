//
//  HelpQChatViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/15/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class HelpQChatViewController: GenericInputView, UITableViewDelegate, UITableViewDataSource {

    /* Information Label */
    @IBOutlet weak var informationView: UIView! // View containing the information
    
    @IBOutlet weak var techLabel: UILabel! // Label containing the technology information
    @IBOutlet weak var languageLabel: UILabel! // Label containing the language information
    @IBOutlet weak var resolutionLabel: UILabel! // Label containing whether if the user has marked this as resolved or not
    @IBOutlet weak var descriptionLabel: UITextView! // Label containing the description of the problem
    
    /* Chat table */
    @IBOutlet weak var chatView: UITableView! // Table containing chat
    
    /* Chat Submisson */
    @IBOutlet weak var chatMessageView: UIView! // View containing chat elements
    @IBOutlet weak var messageField: UITextField! // TextField containing the message the user wants to send
    @IBOutlet weak var sendButton: UIButton! // Send button for the user to send the message contained in messageField.text
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    @IBAction func sendMessage(sender: AnyObject) {
        if messageField.text! == "" {
            view.endEditing(true)
            return
        }
        
        let newChat = Chat(user: currentUser, message: messageField.text!)
        chatItems.append(newChat)
        let indexPath = NSIndexPath(forRow: chatItems.count - 1, inSection: 0)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [unowned self] in
            self.scrollToLast()
        })
        
        /* Configure end behavior */
        chatView.beginUpdates()
        chatView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        chatView.endUpdates()
        messageField.text = "" // Clear text
        CATransaction.commit()
    }
    
    /* label variables */
    var helpqItem: HelpQ!
    
    var chatItems: [Chat]!
    
    var currentUser: String = "Shotaro Ikeda" // TODO: Set dynamically via Core Data
    
    /* Initialize dummy sample item */
    func initializeSample() {
        chatItems = [Chat(user: "Shotaro Ikeda"), Chat(user: "Maritta Terpin"), Chat(user: "Shotaro Ikeda"),
        Chat(user: "Shotaro Ikeda"), Chat(user: "Shotaro Ikeda"), Chat(user: "Maritta Terpin"), Chat(user: "Maritta Terpin"), Chat(user: "Shotaro Ikeda")]
        chatView.reloadData()
    }
    
    override func viewDidLoad() {
        /* Variables for super class */
        textFields = [messageField]
        textViews = []
        scroll = nil
        
        super.viewDidLoad()
        
        techLabel.text = helpqItem.technology
        languageLabel.text = helpqItem.language
        
        if helpqItem.resolved {
            resolutionLabel.text = "Resolved"
            resolutionLabel.textColor = UIColor.greenColor()
        } else {
            resolutionLabel.text = "Unresolved"
            resolutionLabel.textColor = UIColor.redColor()
        }
        
        descriptionLabel.text = helpqItem.description
        
        /* ChatView */
        // Set delegates first
        chatView.delegate = self
        chatView.dataSource = self
        // Initalize sample data
        initializeSample() // reloads data
        // Configure cells
        chatView.estimatedRowHeight = 50
        chatView.rowHeight = UITableViewAutomaticDimension
        
        chatViewScrollToBottom(delay: 0.1, animated: false) // See the comment in the function
    }
    
    
    /* Scrolls table view to the bottom. Turns out attempting to move the tableView in viewDidLoad / viewDidAppear would not work at all */
    func chatViewScrollToBottom(delay delay: Double, animated: Bool) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfRows = self.chatItems.count
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: 0)
                self.chatView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    /* Better way to animate */
    func scrollToLast() {
        guard chatItems.count > 0 else {
            return
        }
        
        CATransaction.begin()
        /*
        CATransaction.setCompletionBlock({ [unowned self] in
            // Scroll and animate once completed
            self.chatView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chatItems.count - 1 , inSection: 0), atScrollPosition: .Bottom, animated: true)
        })
        */
        
        // scroll down 1 point to have the bubble render first
        let newContentOffset = CGPointMake(0, chatView.contentOffset.y + 100)
        chatView.setContentOffset(newContentOffset, animated: false)
        
        CATransaction.commit()
    }
    
    /* Mark: Override for TextField Delegate */
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage(textField)
        return false
    }
    
    /* Need to override the keyboard functions, or else it will crash. (scroll is nil) */
    override func keyboardWillAppear(notification: NSNotification) {
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.bottomLayoutConstraint.constant = keyboardFrame.height
            }, completion: { _ in
                // Scroll down
                let rect = CGRectMake(0, self.chatView.contentSize.height - self.chatView.bounds.size.height, self.chatView.bounds.size.width, self.chatView.bounds.size.height)
                self.chatView.scrollRectToVisible(rect, animated: true)
        })
        
    }
    
    override func keyboardWillDisappear(notification: NSNotification) {
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.bottomLayoutConstraint.constant = 0
        })
    }
    
    // Mark: UITableViewDelegates and UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chat = chatItems[indexPath.row]
        if chat.user == currentUser {
            let cell = tableView.dequeueReusableCellWithIdentifier("my_response") as! MyChatTableViewCell
            cell.chatLabel.text = chat.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("other_response") as! OtherChatTableViewCell
            cell.chatLabel.text = chat.message
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

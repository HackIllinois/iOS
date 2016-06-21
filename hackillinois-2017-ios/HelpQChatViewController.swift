//
//  HelpQChatViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/15/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import CoreData

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
        /* Simply close the view if user did not input text */
        if messageField.text! == "" {
            view.endEditing(true)
            return
        }
        
        /* Create a Chat to save to the model + display to the user */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: appDelegate.managedObjectContext) as! Chat
        newChat.initialize(currentUser, message: messageField.text!)
        chatItems.append(newChat) // Show up on user's end first!
        helpqItem.pushChatItem(chat: newChat) // Save data and record
        
        /* Insert row and scroll there */
        let indexPath = NSIndexPath(forRow: chatItems.count - 1, inSection: 0)
        chatView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        chatView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
        /* Reset text field */
        messageField.text = ""
    }
    
    /* label variables */
    var helpqItem: HelpQ!
    
    var chatItems: [Chat]! // uses this array to display data. User interaction is quite normal for chatting, so did not use NSFetchedResultsController
    
    var currentUser: String = "Shotaro Ikeda" // TODO: Set dynamically via Core Data
    
    var heightAtIndexPath = NSMutableDictionary() // Cache of how large the heights are
    
    /* Initialize dummy sample item */
    func loadSavedData() {
        let arr = helpqItem.chats.array as! [Chat]
        if arr.isEmpty {
            print("Populating Items with sample chat data")
            // TODO: Remove auto population if empty
            /* Populate sample if empty */
            let chatInsert: (String -> Chat) = { name in
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: appDelegate.managedObjectContext) as! Chat
                chat.initialize(name)
                return chat
            } // Lambda function used here for quick access (code conversion)
            
            chatItems = [chatInsert("Shotaro Ikeda"), chatInsert("Maritta Terpin"), chatInsert("Shotaro Ikeda"),
                         chatInsert("Shotaro Ikeda"), chatInsert("Shotaro Ikeda"), chatInsert("Maritta Terpin"), chatInsert("Maritta Terpin"), chatInsert("Shotaro Ikeda")]
            helpqItem.chats = NSOrderedSet(array: chatItems)
            Helpers.saveContext()
        } else {
            chatItems = arr
        }
        
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
        
        if helpqItem.resolved.boolValue {
            resolutionLabel.text = "Resolved"
            resolutionLabel.textColor = UIColor.greenColor()
        } else {
            resolutionLabel.text = "Unresolved"
            resolutionLabel.textColor = UIColor.redColor()
        }
        
        descriptionLabel.text = helpqItem.desc
        
        /* ChatView */
        // Set delegates first
        chatView.delegate = self
        chatView.dataSource = self
        // Initalize sample data
        loadSavedData() // reloads data
        
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
    
    /* Mark: Override for TextField Delegate */
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage(textField)
        return false
    }
    
    /* Need to override the keyboard functions, or else it will crash. (scroll is nil) */
    override func keyboardWillAppear(notification: NSNotification) {
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        self.bottomLayoutConstraint.constant = keyboardFrame.height
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.view.layoutIfNeeded() // Animate the constraint
            self.chatView.setContentOffset(CGPoint(x: 0, y: self.chatView.contentOffset.y + keyboardFrame.height), animated: false)
        })
    }
    
    override func keyboardWillDisappear(notification: NSNotification) {
        var keyboardFrame:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        let offset = CGPoint(x: 0, y: isCellVisible() ? 0 : chatView.contentOffset.y - keyboardFrame.height) // Only set the offset if the last cell is not visible to avoid clunky animations
        
        self.bottomLayoutConstraint.constant = 0
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue, animations: {
            self.view.layoutIfNeeded() // Animate constraint
            self.chatView.setContentOffset(offset, animated: false)
        })
    }
    
    func isCellVisible() -> Bool {
        if let visibleCells = chatView.indexPathsForVisibleRows {
            for index in visibleCells {
                if index == chatItems.count {
                    return true
                }
            }
        }
        
        return false
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
    
    /* Helper function to calculate height of label */
    func heightForLabel(withText text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit() // Calculate height
        
        return label.bounds.height + 26 // Extra padding or else the string gets truncated....
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = heightAtIndexPath.objectForKey(indexPath) as? CGFloat {
            return height
        } else {
            let height = heightForLabel(withText: chatItems[indexPath.row].message, font: UIFont.systemFontOfSize(17), width: 207.5) // Subtract padding from Width
            heightAtIndexPath.setObject(height, forKey: indexPath)
            return height
        }
    }
}

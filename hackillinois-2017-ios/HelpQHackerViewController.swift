//
//  HelpQHackerViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

enum Resolution: Int {
    case unresolved = 0
    case resolved
}

class HelpQHackerViewController: GenericCardViewController, UICollectionViewDataSource {

    @IBOutlet weak var helpQCollection: UICollectionView!
    
    /* Data items */
    var items: [[HelpQ]]! = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Collection View */
        helpQCollection.dataSource = self
        helpQCollection.delegate = self
        
        let unresolvedItems = [HelpQ(), HelpQ(), HelpQ()]
        let resolvedItems = [HelpQ(), HelpQ(), HelpQ(), HelpQ()]
        items = [unresolvedItems, resolvedItems]
        
        /* Add a button up to to allow users to create new tickets */
        navigationController!.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Done, target: self, action: #selector(createTicket))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Navigation Function */
    func createTicket() {
        let ticketController = UIStoryboard.init(name: "HelpQ_Hacker", bundle: nil).instantiateViewControllerWithIdentifier("helpq_submit_request") as! HelpQSubmissionViewController
        ticketController.addToList = { [unowned self] item in
            self.items[Resolution.unresolved.rawValue].insert(item, atIndex: 0)
            self.helpQCollection.reloadData()
        }
        presentViewController(ticketController, animated: true, completion: nil)
    }
    
    /* Button action */
    func moveCellFromResolvedToUnresolved(sender: UIButton) {
        let item = items[Resolution.resolved.rawValue][sender.tag]
        item.resolved = false
        item.updateModifiedTime()
        
        items[Resolution.resolved.rawValue].removeAtIndex(sender.tag)
        items[Resolution.unresolved.rawValue].insert(item, atIndex: 0)
        
        helpQCollection.reloadData()
    }
    
    func moveCellFromUnresolvedToResolved(sender: UIButton) {
        let item = items[Resolution.unresolved.rawValue][sender.tag]
        item.resolved = true
        item.updateModifiedTime()
        
        items[Resolution.unresolved.rawValue].removeAtIndex(sender.tag)
        items[Resolution.resolved.rawValue].insert(item, atIndex: 0)
        
        helpQCollection.reloadData()
    }
    
    /* UICollectionViewDataSource */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = helpQCollection.dequeueReusableCellWithReuseIdentifier("hacker_helpq_cell", forIndexPath: indexPath) as! HelpQHackerCollectionViewCell
        
        let item = items[indexPath.section][indexPath.row]
        
        /* Configure cell */
        cell.techLabel.text = item.technology
        cell.descriptionLabel.text = item.description
        configureCell(cell: cell)
        
        /* Section specific configuration */
        switch indexPath.section {
        case Resolution.unresolved.rawValue:
            cell.resolveButton.setTitle("Mark as Resolved", forState: .Normal)
            cell.resolveButton.tag = indexPath.row // way to distingish what button was pressed
            cell.resolveButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.resolveButton.addTarget(self, action: #selector(moveCellFromUnresolvedToResolved), forControlEvents: .TouchUpInside)
        case Resolution.resolved.rawValue:
            cell.resolveButton.setTitle("Mark as Unresolved", forState: .Normal)
            cell.resolveButton.tag = indexPath.row // way to distingish what button was pressed
            cell.resolveButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.resolveButton.addTarget(self, action: #selector(moveCellFromResolvedToUnresolved), forControlEvents: .TouchUpInside)
        default:
            break
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = helpQCollection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "hacker_helpq_unresolved_header", forIndexPath: indexPath) as! HelpQHackerCollectionReusableView
        
        /* Section specific configuration */
        switch indexPath.section {
        case Resolution.unresolved.rawValue:
            header.titleLabel.text = "Unresolved"
        case Resolution.resolved.rawValue:
            header.titleLabel.text = "Resolved"
        default:
            break
        }
        
        return header
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_chat_view" {
            let destination = segue.destinationViewController as! HelpQChatViewController
            let indexPath = helpQCollection.indexPathsForSelectedItems()!.first!
            let object = items[indexPath.section][indexPath.row]
            
            destination.helpqItem = object
        }
    }
}

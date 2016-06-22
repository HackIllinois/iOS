//
//  HelpQHackerViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

enum Resolution: Int {
    case unresolved = 0
    case resolved
}

class HelpQHackerViewController: GenericCardViewController, UICollectionViewDataSource {

    @IBOutlet weak var helpQCollection: UICollectionView!
    
    /* Data items */
    var items: [[HelpQ]]! = []
    
    func loadItems() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let unresolvedFetch = NSFetchRequest(entityName: "HelpQ")
        let sort = NSSortDescriptor(key: "modified", ascending: false)
        let unresolvedPredicate = NSPredicate(format: "resolved == %@", NSNumber(bool: false))
        
        unresolvedFetch.sortDescriptors = [sort]
        unresolvedFetch.predicate = unresolvedPredicate
        
        let resolvedPredicate = NSPredicate(format: "resolved == %@", NSNumber(bool: false))
        let resolvedFetch = unresolvedFetch.copy() as! NSFetchRequest
        resolvedFetch.predicate = resolvedPredicate
        
        var unresolvedItems: [HelpQ]!
        var resolvedItems: [HelpQ]!
        
        do {
            unresolvedItems = try appDelegate.managedObjectContext.executeFetchRequest(unresolvedFetch) as! [HelpQ]
            resolvedItems = try appDelegate.managedObjectContext.executeFetchRequest(resolvedFetch) as! [HelpQ]
        } catch {
            print("Error while loading \(error)")
        }
        
        /* Create data if it does not exist */
        // TODO: Remove for final product
        if unresolvedItems.isEmpty && resolvedItems.isEmpty {
            print("Creating Dummy Data")
            let createHelpQLambda: (String, String, String, String) -> HelpQ = { (tech, lang, loc, desc) in
                let helpQ = NSEntityDescription.insertNewObjectForEntityForName("HelpQ", inManagedObjectContext: appDelegate.managedObjectContext) as! HelpQ
                helpQ.initialize(tech, language: lang, location: loc, description: desc)
                return helpQ
            }
            
            unresolvedItems = [createHelpQLambda("Node JS", "Javascript", "Siebel 2202", "Help with Asynchronous Calls"), createHelpQLambda("Memory Allocation/Deallocation", "C++", "Siebel 1404","Help with unknown use after free error"), createHelpQLambda("Threading", "C", "ECEB 2201","Cannot figure out how to multithread my code.")]
            resolvedItems = [createHelpQLambda("Python", "Python", "Siebel", "How to print with python"), createHelpQLambda("UITableView", "iOS", "Find me around ECEB labs", "Automatic Dimension is creates strange behavior for animations"), createHelpQLambda("Machine Learning", "Python", "Labs at Siebel", "Which model to use?"), createHelpQLambda("MySQL", "Python-Flask", "around 2nd floor DCL", "How do I connect Python to my database?")]
            Helpers.saveContext()
        }
        
        /* Store data in provided array */
        items = [unresolvedItems, resolvedItems]
        helpQCollection.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Collection View */
        helpQCollection.dataSource = self
        helpQCollection.delegate = self
        
        helpQCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        // Load items
        loadItems()
        
        /* Add a button up to to allow users to create new tickets */
        navigationController!.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_create"), style: .Done, target: self, action: #selector(createTicket))
    }

    /* Navigation Function */
    func createTicket() {
        let ticketController = UIStoryboard.init(name: "HelpQ_Create", bundle: nil).instantiateInitialViewController() as! HelpQSubmissionViewController
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
        cell.descriptionLabel.text = item.desc
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

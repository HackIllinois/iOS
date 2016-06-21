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
    var fetchedResultsController: NSFetchedResultsController!
    
    /* Core Data Portion */
    func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetch = NSFetchRequest(entityName: "HelpQ")
            let sort = NSSortDescriptor(key: "modified", ascending: false)
            fetch.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "resolved", cacheName: nil)
        }
        
        do {
            try self.fetchedResultsController.performFetch()
            self.helpQCollection.reloadData()
        } catch {
            print("Error loading \(error)")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Collection View */
        helpQCollection.dataSource = self
        helpQCollection.delegate = self
        
        helpQCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        /*
        let unresolvedItems = [HelpQ(), HelpQ(), HelpQ()]
        let resolvedItems = [HelpQ(), HelpQ(), HelpQ(), HelpQ()]
        items = [unresolvedItems, resolvedItems]
        */
        
        /* Add a button up to to allow users to create new tickets */
        navigationController!.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Done, target: self, action: #selector(createTicket))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Navigation Function */
    func createTicket() {
        let ticketController = UIStoryboard.init(name: "HelpQ_Create", bundle: nil).instantiateInitialViewController() as! HelpQSubmissionViewController
        ticketController.addToList = { [unowned self] in
            Helpers.saveContext()
            self.helpQCollection.reloadData()
        }
        presentViewController(ticketController, animated: true, completion: nil)
    }
    
    /* Button action */
    func moveCellFromResolvedToUnresolved(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: Resolution.resolved.rawValue)
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        item.resolved = false
        item.updateModifiedTime()
        
        Helpers.saveContext()
        loadSavedData()
    }
    
    func moveCellFromUnresolvedToResolved(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: Resolution.unresolved.rawValue)
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        item.resolved = true
        item.updateModifiedTime()
        
        Helpers.saveContext()
        loadSavedData()
    }
    
    /* UICollectionViewDataSource */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = helpQCollection.dequeueReusableCellWithReuseIdentifier("hacker_helpq_cell", forIndexPath: indexPath) as! HelpQHackerCollectionViewCell
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        
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
            let object = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
            
            destination.helpqItem = object
        }
    }
}

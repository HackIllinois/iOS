//
//  HelpQStaffViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HelpQStaffViewController: GenericHelpQStaffViewController  {

    @IBOutlet weak var helpQCollection: UICollectionView!
    
    /* Core Data functions */
    override func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetch = NSFetchRequest(entityName: "HelpQ")
            let languageSort = NSSortDescriptor(key: "language", ascending: false)
            let inChargeSort = NSSortDescriptor(key: "isHelping", ascending: false)
            let modifiedSort = NSSortDescriptor(key: "modified", ascending: false)
            fetch.sortDescriptors = [inChargeSort, languageSort, modifiedSort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "language", cacheName: nil)
        }
        
        fetchedResultsController.fetchRequest.predicate = fetchPredicate
        
        do {
            try self.fetchedResultsController.performFetch()
            self.helpQCollection.reloadData()
        } catch {
            print("Error loading: \(error)")
        }
    }
    
    // Mark: UIViewController Functions
    override func viewDidLoad() {
        collectionView = helpQCollection
        super.viewDidLoad()
    }
    
    // Mark: Button Handler
    func cellButtonPressed(sender: ReferencedButton) {
        let helpQItem = sender.referenceObject as! HelpQ
        
        /* Configure button */
        if !helpQItem.isHelping.boolValue {
            helpQItem.assignMentor(mentor: user.name, helpStatus: true)
            sender.setTitle("Stop Helping User", forState: .Normal)
        } else {
            helpQItem.assignMentor(mentor: "", helpStatus: false)
            sender.setTitle("Help User", forState: .Normal)
        }
        
        saveAndReload()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("staff_helpq_cell", forIndexPath: indexPath) as! HelpQStaffCollectionViewCell
        configureCell(cell: cell)
        
        let helpQItem: HelpQ = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        /* Configure cell with object parameters */
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        cell.helpButton.referenceObject = helpQItem // Add a reference to the object in order to modify it
        
        // Set the button title depending on the status
        if helpQItem.isHelping.boolValue {
            cell.helpButton.setTitle("Stop Helping User", forState: .Normal)
        } else {
            cell.helpButton.setTitle("Help User", forState: .Normal)
        }
        cell.helpButton.addTarget(self, action: #selector(cellButtonPressed), forControlEvents: .TouchUpInside)
        
        return cell
    }
 
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = helpQCollection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "staff_helpq_header", forIndexPath: indexPath) as! HelpQHackerCollectionReusableView
        
        let helpQItem = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        header.titleLabel.text = helpQItem.language
        
        return header
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

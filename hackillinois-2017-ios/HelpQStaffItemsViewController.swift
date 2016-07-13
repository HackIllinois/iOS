//
//  HelpQStaffItemsViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/30/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HelpQStaffItemsViewController: GenericHelpQStaffViewController {
    /* UI Items */
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    /* Mark: CoreData Functions */
    override func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetchRequest = NSFetchRequest(entityName: "HelpQ")
            
            // Sort by resolved, then by modified time
            let resolvedSort = NSSortDescriptor(key: "resolved", ascending: false)
            let modifiedSort = NSSortDescriptor(key: "modified", ascending: false)
            fetchRequest.sortDescriptors = [resolvedSort, modifiedSort]
            
            // Only show items that the user is helping
            let predicate = NSPredicate(format: "isHelping == %@", true)
            fetchRequest.predicate = predicate
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "resolved", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            itemCollectionView.reloadData()
        } catch {
            print("Error loading items: \(error)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Need to reload here since the data components may have changed in other views
        super.viewDidAppear(animated)
        loadSavedData()
    }

    override func viewDidLoad() {
        /* Set super classes' collectionView */
        collectionView = itemCollectionView
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSavedData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Mark: UIButtonAction */
    func helpButtonPressed(sender: UIButton) {
        print("Button pressed")
        let sender: ReferencedButton = sender as! ReferencedButton
        let helpQItem: HelpQ = sender.referenceObject as! HelpQ
        
        if helpQItem.isHelping.boolValue {
            // User stopped helping
            helpQItem.mentor = ""
        } else {
            // User started to help
            helpQItem.mentor = user.name
        }
        
        // TODO: Update current item with whatever is on the database
        helpQItem.isHelping = NSNumber(bool: !helpQItem.isHelping.boolValue)
        saveAndReload()
    }
    
    /* Mark UICollectionViewDelegate */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCellWithReuseIdentifier("staff_helpq_cell", forIndexPath: indexPath) as! HelpQStaffItemCollectionViewCell
        let helpQItem = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        
        configureCell(cell: cell)
        
        // Configure Cell
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        
        // Help Button
        cell.helpButton.referenceObject = helpQItem
        cell.helpButton.addTarget(self, action: #selector(helpButtonPressed), forControlEvents: .TouchUpInside)
        if helpQItem.isHelping.boolValue {
            cell.helpButton.setTitle("Stop Helping User", forState: .Normal)
        } else {
            cell.helpButton.setTitle("Help User", forState: .Normal)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let helpQItem = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "staff_helpq_header", forIndexPath: indexPath) as! HelpQHackerCollectionReusableView
        if helpQItem.resolved.boolValue {
            header.titleLabel.text = "Items Complete"
        } else {
            header.titleLabel.text = "Current HelpQ Items"
        }
        
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

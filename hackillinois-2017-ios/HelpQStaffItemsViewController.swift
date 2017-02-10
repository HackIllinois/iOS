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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let fetchRequest = NSFetchRequest<HelpQ>(entityName: "HelpQ")
            
            // Sort by resolved, then by modified time
            let resolvedSort = NSSortDescriptor(key: "resolved", ascending: false)
            let modifiedSort = NSSortDescriptor(key: "modified", ascending: false)
            fetchRequest.sortDescriptors = [resolvedSort, modifiedSort]
            
            // Only show items that the user is helping
            let predicate = NSPredicate(format: "isHelping == %@", true as CVarArg)
            fetchRequest.predicate = predicate
            
            fetchedResultsController = NSFetchedResultsController<HelpQ>(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "resolved", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            itemCollectionView.reloadData()
        } catch {
            print("Error loading items: \(error)")
        }
    }

    override func viewDidLoad() {
        /* Set super classes' collectionView */
        collectionView = itemCollectionView
        super.viewDidLoad()
    }
    
    /* Mark: UIButtonAction */
    func helpButtonPressed(_ sender: UIButton) {
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
        helpQItem.isHelping = NSNumber(value: !helpQItem.isHelping.boolValue as Bool)
        saveAndReload()
    }
    
    /* Mark UICollectionViewDelegate */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: "staff_helpq_cell", for: indexPath) as! HelpQStaffItemCollectionViewCell
        let helpQItem = fetchedResultsController.object(at: indexPath) 
        
        configureCell(cell)
        
        // Configure Cell
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        
        // Help Button
        cell.helpButton.referenceObject = helpQItem
        cell.helpButton.addTarget(self, action: #selector(helpButtonPressed), for: .touchUpInside)
        if helpQItem.isHelping.boolValue {
            cell.helpButton.setTitle("Stop Helping User", for: UIControlState())
        } else {
            cell.helpButton.setTitle("Help User", for: UIControlState())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let helpQItem = fetchedResultsController.object(at: indexPath) 
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "staff_helpq_header", for: indexPath) as! HelpQHackerCollectionReusableView
        if helpQItem.resolved.boolValue {
            header.titleLabel.text = "Items Complete"
        } else {
            header.titleLabel.text = "Current HelpQ Items"
        }
        
        return header
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_helpq_chat" {
            let destinationViewController: HelpQChatViewController = segue.destination as! HelpQChatViewController
            let indexPath: IndexPath? = itemCollectionView.indexPathsForSelectedItems?.first
            destinationViewController.helpqItem = fetchedResultsController.object(at: indexPath!)
        }
    }

}

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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let fetch = NSFetchRequest<HelpQ>(entityName: "HelpQ")
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
    func cellButtonPressed(_ sender: ReferencedButton) {
        let helpQItem = sender.referenceObject as! HelpQ
        
        /* Configure button */
        if !helpQItem.isHelping.boolValue {
            helpQItem.assignMentor(mentor: user.name, helpStatus: true)
            sender.setTitle("Stop Helping User", for: UIControlState())
        } else {
            helpQItem.assignMentor(mentor: "", helpStatus: false)
            sender.setTitle("Help User", for: UIControlState())
        }
        
        saveAndReload()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "staff_helpq_cell", for: indexPath) as! HelpQStaffCollectionViewCell
        configureCell(cell)
        
        let helpQItem: HelpQ = fetchedResultsController.object(at: indexPath) 
        /* Configure cell with object parameters */
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        cell.helpButton.referenceObject = helpQItem // Add a reference to the object in order to modify it
        
        // Set the button title depending on the status
        if helpQItem.isHelping.boolValue {
            cell.helpButton.setTitle("Stop Helping User", for: UIControlState())
        } else {
            cell.helpButton.setTitle("Help User", for: UIControlState())
        }
        cell.helpButton.addTarget(self, action: #selector(cellButtonPressed), for: .touchUpInside)
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let header = helpQCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "staff_helpq_header", for: indexPath) as! HelpQHackerCollectionReusableView
        
        let helpQItem = fetchedResultsController.object(at: indexPath) 
        header.titleLabel.text = helpQItem.language
        
        return header
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "to_helpq_chat" {
            let destinationViewController: HelpQChatViewController = segue.destination as! HelpQChatViewController
            let indexPath: IndexPath? = helpQCollection.indexPathsForSelectedItems?.first
            destinationViewController.helpqItem = fetchedResultsController.object(at: indexPath!) 
        }
    }

}

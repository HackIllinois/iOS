//
//  HelpQStaffItemsViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/30/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HelpQStaffItemsViewController: GenericCardViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource {
    /* UI Items */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /* Core Data */
    var fetchedResultsController: NSFetchedResultsController!
    
    func loadSavedData() {
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
            collectionView.reloadData()
        } catch {
            print("Error loading items: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSavedData()
        
        // The other view populates the data items. There is a good chance that we will have duplicates if we populate them in this view
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Mark: UICollectionViewDataSource */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    /* Mark UICollectionViewDelegate */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("", forIndexPath: indexPath) as! HelpQStaffItemCollectionViewCell
        let helpQItem = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        
        // Configure Cell
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        
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

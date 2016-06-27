//
//  HelpQStaffViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/14/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HelpQStaffViewController: GenericCardViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource {

    @IBOutlet weak var helpQCollection: UICollectionView!
    
    /* Core Data components */
    var fetchedResultsController: NSFetchedResultsController!
    var fetchPredicate: NSPredicate!
    
    /* Core Data functions */
    func loadSavedData() {
        if fetchedResultsController == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetch = NSFetchRequest(entityName: "HelpQ")
            let inChargeSort = NSSortDescriptor(key: "isHelping", ascending: false)
            let modifiedSort = NSSortDescriptor(key: "modified", ascending: false)
            fetch.sortDescriptors = [inChargeSort, modifiedSort]
            
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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchPredicate = nil
        loadSavedData()
        
        // Set delegates
        fetchedResultsController.delegate = self
        helpQCollection.dataSource = self
        helpQCollection.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Button Handler
    func cellButtonPressed(sender: ReferencedButton) {
        let helpQItem = sender.referenceObject as! HelpQ
        // TODO: set mentor as me
        helpQItem.assignMentor(mentor: "me", helpStatus: true)
    }
    
    // Mark: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("staff_helpq_cell", forIndexPath: indexPath) as! HelpQStaffCollectionViewCell
        configureCell(cell: cell)
        
        let helpQItem: HelpQ = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        /* Configure cell with object parameters */
        cell.techLabel.text = helpQItem.technology
        cell.descLabel.text = helpQItem.desc
        cell.helpButton.referenceObject = helpQItem // Add a reference to the object in order to modify it
        cell.helpButton.addTarget(self, action: #selector(cellButtonPressed), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = helpQCollection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "staff_helpq_header", forIndexPath: indexPath) as! HelpQHackerCollectionReusableView
        
        let helpQItem = fetchedResultsController.objectAtIndexPath(indexPath) as! HelpQ
        
        // Split between ones that person is currently helping and the rest
        if helpQItem.isHelping.boolValue {
            header.titleLabel.text = "Current Items"
        } else {
            header.titleLabel.text = helpQItem.language
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

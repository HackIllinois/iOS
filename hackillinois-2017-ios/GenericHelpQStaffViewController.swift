//
//  GenericHelpQStaffViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 7/13/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class GenericHelpQStaffViewController: GenericCardViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    /* User Information */
    var user: User = (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User])[0]
    
    /* Core Data components */
    var fetchedResultsController: NSFetchedResultsController<HelpQ>!
    var fetchPredicate: NSPredicate!
    
    /* Core Data functions */
    func loadSavedData() {
        fatalError("Super classes loadSavedData was called, child class must override loadSavedData.")
    }
    
    func saveAndReload() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            CoreDataHelpers.saveContextMainThread()
            DispatchQueue.main.async {
                self.loadSavedData()
            }
        }
    }
    
    /* MARK: Population of sample data */
    func populateSampleData() {
        print("Creating Dummy Data")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let createHelpQLambda: (String, String, String, String) -> HelpQ = { (tech, lang, loc, desc) in
            let helpQ = NSEntityDescription.insertNewObject(forEntityName: "HelpQ", into: appDelegate.managedObjectContext) as! HelpQ
            helpQ.initialize(technology: tech, language: lang, location: loc, description: desc)
            return helpQ
        }
        
        let h1 = createHelpQLambda("Node JS", "Javascript", "Siebel 2202", "Help with Asynchronous Calls")
        h1.isHelping = NSNumber(value: true as Bool)
        let _ = createHelpQLambda("Memory Allocation/Deallocation", "C++", "Siebel 1404","Help with unknown use after free error")
        _ = createHelpQLambda("Threading", "C", "ECEB 2201","Cannot figure out how to multithread my code.")
        _ = createHelpQLambda("Python", "Python", "Siebel", "How to print with python")
        _ = createHelpQLambda("UITableView", "iOS", "Find me around ECEB labs", "Automatic Dimension is creates strange behavior for animations")
        _ = createHelpQLambda("Machine Learning", "Python", "Labs at Siebel", "Which model to use?")
        _ = createHelpQLambda("MySQL", "Python-Flask", "around 2nd floor DCL", "How do I connect Python to my database?")
        
        saveAndReload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Using fetchedResultsController makes it so we need to fetch modified data everytime user wants to 
        // see the view
        super.viewDidAppear(animated)
        loadSavedData()
    }
    
    // Mark: UIViewController Functions
    override func viewDidLoad() {
        guard collectionView != nil else {
            fatalError("You must set the collection view before calling the super classes' viewDidLoad function")
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchPredicate = nil
        loadSavedData()
        
        // Set delegates
        fetchedResultsController.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        /* Remove for production */
        if fetchedResultsController.fetchedObjects?.count == 0 {
            populateSampleData()
        }
        
        /* Configure collectionView for consistency */
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    
    /*
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
    */
    
    // Mark: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    // Mark: Dummy UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Super classes cellForItemAtIndexPath was called, child classes must override this method.")
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

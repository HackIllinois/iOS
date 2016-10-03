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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let unresolvedFetch = NSFetchRequest<HelpQ>(entityName: "HelpQ")
        let sort = NSSortDescriptor(key: "modified", ascending: false)
        let unresolvedPredicate = NSPredicate(format: "resolved == %@", NSNumber(value: false as Bool))
        
        unresolvedFetch.sortDescriptors = [sort]
        unresolvedFetch.predicate = unresolvedPredicate
        
        let resolvedPredicate = NSPredicate(format: "resolved == %@", NSNumber(value: false as Bool))
        let resolvedFetch = unresolvedFetch.copy() as! NSFetchRequest<HelpQ>
        resolvedFetch.predicate = resolvedPredicate
        
        var unresolvedItems: [HelpQ]!
        var resolvedItems: [HelpQ]!
        
        do {
            unresolvedItems = try appDelegate.managedObjectContext.fetch(unresolvedFetch)
            resolvedItems = try appDelegate.managedObjectContext.fetch(resolvedFetch) 
        } catch {
            print("Error while loading \(error)")
        }
        
        /* Create data if it does not exist */
        // TODO: Remove for final product
        if unresolvedItems.isEmpty && resolvedItems.isEmpty {
            print("Creating Dummy Data")
            let createHelpQLambda: (String, String, String, String) -> HelpQ = { (tech, lang, loc, desc) in
                let helpQ = NSEntityDescription.insertNewObject(forEntityName: "HelpQ", into: appDelegate.managedObjectContext) as! HelpQ
                helpQ.initialize(technology: tech, language: lang, location: loc, description: desc)
                return helpQ
            }
            
            unresolvedItems = [createHelpQLambda("Node JS", "Javascript", "Siebel 2202", "Help with Asynchronous Calls"), createHelpQLambda("Memory Allocation/Deallocation", "C++", "Siebel 1404","Help with unknown use after free error"), createHelpQLambda("Threading", "C", "ECEB 2201","Cannot figure out how to multithread my code.")]
            resolvedItems = [createHelpQLambda("Python", "Python", "Siebel", "How to print with python"), createHelpQLambda("UITableView", "iOS", "Find me around ECEB labs", "Automatic Dimension is creates strange behavior for animations"), createHelpQLambda("Machine Learning", "Python", "Labs at Siebel", "Which model to use?"), createHelpQLambda("MySQL", "Python-Flask", "around 2nd floor DCL", "How do I connect Python to my database?")]
            CoreDataHelpers.saveContext()
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
        navigationController!.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_create"), style: .done, target: self, action: #selector(createTicket))
    }

    /* Navigation Function */
    func createTicket() {
        let ticketController = UIStoryboard.init(name: "HelpQ_Create", bundle: nil).instantiateInitialViewController() as! HelpQSubmissionViewController
        ticketController.addToList = { [unowned self] item in
            self.items[Resolution.unresolved.rawValue].insert(item, at: 0)
            self.helpQCollection.reloadData()
        }
        present(ticketController, animated: true, completion: nil)
    }
    
    /* Button action */
    func moveCellFromResolvedToUnresolved(_ sender: UIButton) {
        let item = items[Resolution.resolved.rawValue][sender.tag]
        item.resolved = false
        item.updateModifiedTime()
        
        items[Resolution.resolved.rawValue].remove(at: sender.tag)
        items[Resolution.unresolved.rawValue].insert(item, at: 0)
        
        helpQCollection.reloadData()
    }
    
    func moveCellFromUnresolvedToResolved(_ sender: UIButton) {
        let item = items[Resolution.unresolved.rawValue][sender.tag]
        item.resolved = true
        item.updateModifiedTime()
        
        items[Resolution.unresolved.rawValue].remove(at: sender.tag)
        items[Resolution.resolved.rawValue].insert(item, at: 0)
        
        helpQCollection.reloadData()
    }
    
    /* UICollectionViewDataSource */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = helpQCollection.dequeueReusableCell(withReuseIdentifier: "hacker_helpq_cell", for: indexPath) as! HelpQHackerCollectionViewCell
        
        let item = items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        /* Configure cell */
        cell.techLabel.text = item.technology
        cell.descriptionLabel.text = item.desc
        configureCell(cell)
        
        /* Section specific configuration */
        switch (indexPath as NSIndexPath).section {
        case Resolution.unresolved.rawValue:
            cell.resolveButton.setTitle("Mark as Resolved", for: UIControlState())
            cell.resolveButton.tag = (indexPath as NSIndexPath).row // way to distingish what button was pressed
            cell.resolveButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.resolveButton.addTarget(self, action: #selector(moveCellFromUnresolvedToResolved), for: .touchUpInside)
        case Resolution.resolved.rawValue:
            cell.resolveButton.setTitle("Mark as Unresolved", for: UIControlState())
            cell.resolveButton.tag = (indexPath as NSIndexPath).row // way to distingish what button was pressed
            cell.resolveButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.resolveButton.addTarget(self, action: #selector(moveCellFromResolvedToUnresolved), for: .touchUpInside)
        default:
            break
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = helpQCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "hacker_helpq_unresolved_header", for: indexPath) as! HelpQHackerCollectionReusableView
        
        /* Section specific configuration */
        switch (indexPath as NSIndexPath).section {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_chat_view" {
            let destination = segue.destination as! HelpQChatViewController
            let indexPath = helpQCollection.indexPathsForSelectedItems!.first!
            let object = items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            destination.helpqItem = object
        }
    }
}

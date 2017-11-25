//
//  HIAnnouncmentsViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIAnnouncmentsViewController: HIBaseViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Announcement> = {
        let fetchRequest: NSFetchRequest<Announcement> = Announcement.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

}

// MARK: - IBActions
extension HIAnnouncmentsViewController {

}

// MARK: - UIViewController
extension HIAnnouncmentsViewController {

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if let indexPath = sender as? IndexPath, let eventDetailViewController = segue.destination as? HIEventDetailViewController {
//            eventDetailViewController.model = fetchedResultsController.object(at: indexPath)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        collectionView?.register(UINib(nibName: HIAnnouncementCell.IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: HIAnnouncementCell.IDENTIFIER)
//        collectionView?.register(UINib(nibName: HIDateHeader.IDENTIFIER, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HIDateHeader.IDENTIFIER)

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        try! fetchedResultsController.performFetch()
    }

}

// MARK: - UICollectionViewDataSource
extension HIAnnouncmentsViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HIAnnouncementCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIAnnouncementCell {
            //            cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "announcement"
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HIAnnouncmentsViewController {

}



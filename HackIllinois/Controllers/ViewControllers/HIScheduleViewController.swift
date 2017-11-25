//
//  HIScheduleViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/19/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HIScheduleViewController: HIBaseViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

}

// MARK: - IBActions
extension HIScheduleViewController {
    @IBAction func launchGet() {
        HIAnnouncementService.getAllAnnouncements()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)

        HIEventService.getAllEvents()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)

        HIEventService.getAllLocations()
        .onSuccess { (contained) in
            print(contained)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)
    }
}

// MARK: - UIViewController
extension HIScheduleViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let indexPath = sender as? IndexPath, let eventDetailViewController = segue.destination as? HIEventDetailViewController {
            eventDetailViewController.model = fetchedResultsController.object(at: indexPath)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // HIBaseViewController
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        setupRefreshControl()

        // CollectionView
        collectionView?.register(UINib(nibName: HIEventCell.IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: HIEventCell.IDENTIFIER)
        collectionView?.register(UINib(nibName: HIDateHeader.IDENTIFIER, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HIDateHeader.IDENTIFIER)
//        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: 300, height: 100)

        try! fetchedResultsController.performFetch()
    }
}

// MARK: - UICollectionViewDataSource
extension HIScheduleViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HIEventCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIEventCell {
//            cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "event"
        }
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HIDateHeader.IDENTIFIER, for: indexPath)
//            if let header = header as? HIDateHeader {
//                header.titleLabel.text = "\(indexPath.section + 1):00 pm"
//            }
//            return header
//        default:
//            fatalError("No other supplementary views should be shown")
//        }
//    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - UICollectionViewDelegate
extension HIScheduleViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEventDetail", sender: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - HICollectionViewDelegateFlowLayout
extension HIScheduleViewController {
    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceHeightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
}

// MARK: - UIRefreshControl
extension HIScheduleViewController {
    override func refresh(_ sender: UIRefreshControl) {
        refreshAnimation.play()
    }
}

extension HIScheduleViewController {
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        collectionView?.reloadData()
        (collectionView?.collectionViewLayout as? HICollectionViewFlowLayout)?.reload()
    }
}

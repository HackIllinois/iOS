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
        _fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        collectionView?.register(UINib(nibName: HIEventCell.IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: HIEventCell.IDENTIFIER)
        collectionView?.register(UINib(nibName: HIDateHeader.IDENTIFIER, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HIDateHeader.IDENTIFIER)

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HIDateHeader.IDENTIFIER, for: indexPath)
            if let header = header as? HIDateHeader {
                header.titleLabel.text = "\(indexPath.section + 1):00 pm"
            }
            return header
        default:
            fatalError("No other supplementary views should be shown")
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - UICollectionViewDelegate
extension HIScheduleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowEventDetail", sender: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HIScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let width = collectionView.contentSize.width - insets
        //        let event = fetchedResultsController.object(at: indexPath)
        let height = 80 //19 + 22 * (event.locations.count + 1) + 19
        return CGSize(width: width, height: CGFloat(height))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let width = collectionView.contentSize.width - insets
        let height = 53
        return CGSize(width: width, height: CGFloat(height))
    }
}



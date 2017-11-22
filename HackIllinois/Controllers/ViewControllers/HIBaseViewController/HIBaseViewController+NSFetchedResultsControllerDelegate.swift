//
//  HIBaseViewController+NSFetchedResultsControllerDelegate.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension HIBaseViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateOperations.removeAll()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let _ = collectionView else { return }

        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            let operation = BlockOperation { [weak self] in self?.collectionView?.insertItems(at: [insertIndexPath]) }
            updateOperations.append(operation)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            let operation = BlockOperation { [weak self] in self?.collectionView?.deleteItems(at: [deleteIndexPath]) }
            updateOperations.append(operation)
        case .update:
            guard let updateIndexPath = indexPath else { return }
            let operation = BlockOperation { [weak self] in self?.collectionView?.reloadItems(at: [updateIndexPath]) }
            updateOperations.append(operation)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            let operation = BlockOperation { [weak self] in self?.collectionView?.moveItem(at: fromIndexPath, to: toIndexPath) }
            updateOperations.append(operation)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard let _ = collectionView else { return }

        switch type {
        case .insert:
            let operation = BlockOperation { [weak self] in self?.collectionView?.insertSections([sectionIndex]) }
            updateOperations.append(operation)
        case .delete:
            let operation = BlockOperation { [weak self] in self?.collectionView?.deleteSections([sectionIndex]) }
            updateOperations.append(operation)
        case .update:
            let operation = BlockOperation { [weak self] in self?.collectionView?.reloadSections([sectionIndex]) }
            updateOperations.append(operation)
        case .move:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            self.updateOperations.forEach { $0.start() }
        }) { (_) in
            self.updateOperations.removeAll()
        }
    }

}

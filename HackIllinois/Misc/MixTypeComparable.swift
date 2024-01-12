//
//  MixTypeComparable.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import HIAPI

protocol MixTypeComparable: Comparable {
    associatedtype ComparableType: Comparable
    var comparable: ComparableType { get }
}

extension MixTypeComparable {
    public static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: MixTypeComparable, Self.ComparableType == Other.ComparableType {
        return lhs.comparable < rhs.comparable
    }

    public static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: MixTypeComparable, Self.ComparableType == Other.ComparableType {
        return lhs.comparable == rhs.comparable
    }
}

func diff<T, V>(initial collectionA: [T], final collectionB: [V])
    -> (itemsToDelete: [T], itemsToUpdate: [(T, V)], itemsToInsert: [V])
    where T: MixTypeComparable, V: MixTypeComparable, T.ComparableType == V.ComparableType {
    // Sort both collections.
    let sortedCollectionA = collectionA.sorted { $0.comparable < $1.comparable }
    let sortedCollectionB = collectionB.sorted { $0.comparable < $1.comparable }

    // Create storage for diff output.
    var itemsToDelete = [T]()
    var itemsToUpdate = [(T, V)]()
    var itemsToInsert = [V]()

    // Iterate through both collections.
    var sortedCollectionAIndex = 0
    var sortedCollectionBIndex = 0

    // While elements remain in both collections.
    while sortedCollectionAIndex < sortedCollectionA.count, sortedCollectionBIndex < sortedCollectionB.count {

        // Get the current event from both lists.
        let currentAItem = sortedCollectionA[sortedCollectionAIndex]
        let currentBItem = sortedCollectionB[sortedCollectionBIndex]

        // Compare items.
        if currentAItem.comparable < currentBItem.comparable {
            // The item only appears in collectionA, add to itemsToDelete.
            itemsToDelete.append(currentAItem)
            sortedCollectionAIndex += 1
        } else if currentAItem.comparable == currentBItem.comparable {
            // The item appears in both collections, add to itemsToUpdate.
            itemsToUpdate.append((currentAItem, currentBItem))
            sortedCollectionAIndex += 1
            sortedCollectionBIndex += 1
        } else { // currentAItem.comparable > currentBItem.comparable
            // The item only appears in collectionB, add to itemsToInsert.
            itemsToInsert.append(currentBItem)
            sortedCollectionBIndex += 1
        }
    }

    // Add remaining collectionA events to itemsToDelete.
    if sortedCollectionAIndex < sortedCollectionA.count {
        let events = sortedCollectionA[sortedCollectionAIndex..<sortedCollectionA.count]
        itemsToDelete.append(contentsOf: events)
    }

    // Add remaining collectionB items to itemsToInsert.
    if sortedCollectionBIndex < sortedCollectionB.count {
        let events = sortedCollectionB[sortedCollectionBIndex..<sortedCollectionB.count]
        itemsToInsert.append(contentsOf: events)
    }

    // Return diff result.
    return (
        itemsToDelete: itemsToDelete,
        itemsToUpdate: itemsToUpdate,
        itemsToInsert: itemsToInsert
    )
}

extension HIAPI.Event: MixTypeComparable {
    var comparable: String { return id }
}

extension Event: MixTypeComparable {
    var comparable: String { return id }
}

extension HIAPI.Announcement: MixTypeComparable {
    var comparable: Date { return time }
}

extension Announcement: MixTypeComparable {
    var comparable: Date { return time }
}

extension HIAPI.Location: MixTypeComparable {
    var comparable: String { return name }
}

extension Location: MixTypeComparable {
    var comparable: String { return name }
}

extension HIAPI.Project: MixTypeComparable {
    var comparable: String { return id }
}

extension Project: MixTypeComparable {
    var comparable: String { return id }
}

extension HIAPI.Profile: MixTypeComparable {
    var comparable: String { return userId }
}

extension Profile: MixTypeComparable {
    var comparable: String { return id }
}

extension HIAPI.LeaderboardProfile: MixTypeComparable {
    var comparable: String { return userId }
}

extension LeaderboardProfile: MixTypeComparable {
    var comparable: String { return id ?? "" }
}

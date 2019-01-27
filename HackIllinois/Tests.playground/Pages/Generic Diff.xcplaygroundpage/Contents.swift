//
//  Contents.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/27/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation

protocol MixTypeComparable: Comparable {
    associatedtype ComparableType: Comparable
    var comparable: ComparableType { get }
}

extension MixTypeComparable {
    static func <<Other>(lhs: Self, rhs: Other) -> Bool where Other: MixTypeComparable, Self.ComparableType == Other.ComparableType {
        return lhs.comparable < rhs.comparable
    }

    static func ==<Other>(lhs: Self, rhs: Other) -> Bool where Other: MixTypeComparable, Self.ComparableType == Other.ComparableType {
        return lhs.comparable == rhs.comparable
    }
}

struct TypeA: MixTypeComparable {
    var comparable: String { return name }
    let name: String
}

struct TypeB: MixTypeComparable {
    var comparable: String { return name }
    let name: String
}

print(TypeA(name: "test") == TypeB(name: "test"))
print(TypeA(name: "test") < TypeB(name: "test"))
print(TypeA(name: "testA") == TypeB(name: "testB"))
print(TypeA(name: "testA") < TypeB(name: "testB"))

//func diff<T, V>(initial: T, final: V) where T: Collection, V: Collection, T.Element: MixTypeComparable == V.Element: MixTypeComparable, T.Element.ComparableType == V.Element.ComparableType { }

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

let testCollectionA = [
    TypeA(name: "00"),
    TypeA(name: "01"),
    TypeA(name: "02"),
    TypeA(name: "03"),
    TypeA(name: "04"),
    TypeA(name: "05")
]

let testCollectionB = [
    TypeB(name: "00"),
    TypeB(name: "01"),
    TypeB(name: "02"),
    TypeB(name: "03"),
    TypeB(name: "04"),
    TypeB(name: "05"),
    TypeB(name: "06")
]

let (itemsToDelete, itemsToUpdate, itemsToInsert) = diff(initial: testCollectionA, final: testCollectionB)

print("itemsToDelete:")
print(itemsToDelete.map {"\t\($0.comparable)"}.joined(separator: "\n"))
print("itemsToUpdate:")
print(itemsToUpdate.map {"\t\($0.0.comparable)"}.joined(separator: "\n"))
print("itemsToInsert:")
print(itemsToInsert.map {"\t\($0.comparable)"}.joined(separator: "\n"))

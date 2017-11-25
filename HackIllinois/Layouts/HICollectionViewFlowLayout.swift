//
//  HICollectionViewFlowLayout.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/22/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit


class HICollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    private lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(collectionViewLayout: self)
    }()

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let contentSize = collectionView.contentSize
        let contentRect = CGRect(origin: .zero, size: contentSize)

        // inefficent, asking for layout of every single item in collectionview

        guard let items = super.layoutAttributesForElements(in: contentRect) else {
            dynamicAnimator.removeAllBehaviors()
            return
        }
        if dynamicAnimator.behaviors.count != items.count {
            dynamicAnimator.removeAllBehaviors()
            items.forEach { (item) in
                let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                attachmentBehavior.length = 0.0
                attachmentBehavior.damping = 0.8
                attachmentBehavior.frequency = 1.0
                dynamicAnimator.addBehavior(attachmentBehavior)
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }

    public func reload() {
        dynamicAnimator.removeAllBehaviors()
        prepare()
    }

}


// MARK: - Cellwise paging
extension HICollectionViewFlowLayout  {

//    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//
//        guard let collectionView = collectionView else { return latestOffset }
//
//        let row = roun(
//
//            (proposedContentOffset.y / (itemSize.height + minimumLineSpacing)).rounded()
//
//        let calculatedOffset = row * itemSize.height + row * minimumLineSpacing
//        let targetOffset = CGPoint(x: latestOffset.x, y: calculatedOffset)
//        return targetOffset
//    }

}






class HICollectionViewFlowLayout22: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        // Helpers
        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)

                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)

            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }

        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)

            if let sectionAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
        }

        return newLayoutAttributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
        guard let collectionView = collectionView else { return layoutAttributes }

        // Helpers
        let contentOffsetY = collectionView.contentOffset.y
        var frameForSupplementaryView = layoutAttributes.frame

        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height

        if contentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
        } else if contentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }

        layoutAttributes.frame = frameForSupplementaryView

        return layoutAttributes
    }

    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
        // Helpers
        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))

        // Exit Early
        guard let collectionView = collectionView else { return result }

        // Fetch Number of Items for Section
        let numberOfItems = collectionView.numberOfItems(inSection: section)

        // Exit Early
        guard numberOfItems > 0 else { return result }

        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY

            // Take Header Size Into Account
            result.minimum -= headerReferenceSize.height
            result.maximum -= headerReferenceSize.height

            // Take Section Inset Into Account
            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }

        return result
    }


}

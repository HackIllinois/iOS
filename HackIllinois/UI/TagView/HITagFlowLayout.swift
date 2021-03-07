//
//  HITagFlowLayout.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/6/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

// Reference: https://github.com/shamiul110107/TagView-in-swift
class Row {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }
    func tagLayout(collectionViewWidth: CGFloat) {
        let padding = 10
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}

class HITagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            print("Null")
            return nil
        }
        var rows = [Row]()
        var currentRowY: CGFloat = -1
        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(Row(spacing: 10))
            }
            print("added")
            rows.last?.add(attribute: attribute)
        }
        rows.forEach { $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
        return rows.flatMap { $0.attributes }
    }
}

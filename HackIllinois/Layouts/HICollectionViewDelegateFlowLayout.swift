//
//  HICollectionViewDelegateFlowLayout.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HICollectionViewDelegateFlowLayout {
    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, widthForItemAt indexPath: IndexPath) -> CGFloat

    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceHeightForHeaderInSection section: Int) -> CGFloat
    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceWidthForHeaderInSection section: Int) -> CGFloat
}


extension HICollectionViewDelegateFlowLayout {
    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, widthForItemAt indexPath: IndexPath) -> CGFloat {
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }

        let horizontalContentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let horizontalSectionInsets = collectionViewLayout.sectionInset.left + collectionViewLayout.sectionInset.right
        let width = collectionView.frame.width - horizontalContentInsets - horizontalSectionInsets

        return width
    }

    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceHeightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func hiBaseCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceWidthForHeaderInSection section: Int) -> CGFloat {
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }

        let horizontalContentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let horizontalSectionInsets = collectionViewLayout.sectionInset.left + collectionViewLayout.sectionInset.right
        let width = collectionView.frame.width - horizontalContentInsets - horizontalSectionInsets

        return width
    }

}

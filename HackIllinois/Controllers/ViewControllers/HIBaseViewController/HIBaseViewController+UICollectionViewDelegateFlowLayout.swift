//
//  HIBaseViewController+UICollectionViewDelegateFlowLayout.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/23/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension HIBaseViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = hiBaseCollectionView(collectionView, layout: collectionViewLayout, widthForItemAt: indexPath)
        let height = hiBaseCollectionView(collectionView, layout: collectionViewLayout, heightForItemAt: indexPath)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width  = hiBaseCollectionView(collectionView, layout: collectionViewLayout, referenceWidthForHeaderInSection: section)
        let height = hiBaseCollectionView(collectionView, layout: collectionViewLayout, referenceHeightForHeaderInSection: section)

        return CGSize(width: width, height: height)
    }
}



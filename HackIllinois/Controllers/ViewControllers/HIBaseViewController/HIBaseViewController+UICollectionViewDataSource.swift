//
//  HIBaseViewController+UICollectionViewDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

extension HIBaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = _fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionCount = _fetchedResultsController?.sections?.count else { return 0 }
        return sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("collectionView(_:, cellForRowAt:) must be implemented in a subclass of HIBaseViewController.")
    }
}

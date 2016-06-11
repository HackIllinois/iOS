//
//  GenericCardViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class GenericCardViewController: UIViewController,  UICollectionViewDelegateFlowLayout {
    
    // Mark: Configuration Utility classes
    func configureCell(cell cell: UICollectionViewCell) {
        /* Configure cell */
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 1)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 3.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
    }
    
    // Mark: UICollectionDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Support multiple devices by adding dynamic padding
        let screen = UIScreen.mainScreen().bounds
        return CGSize(width: screen.width - 60, height: screen.height / 3 - 50)
    }
}

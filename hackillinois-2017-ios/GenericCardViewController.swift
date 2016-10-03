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
    func configureCell(_ cell: UICollectionViewCell) {
        /* Configure cell */
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 3.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
    }
    
    // Mark: UICollectionDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Support multiple devices by adding dynamic padding
        let screen = UIScreen.main.bounds
        return CGSize(width: screen.width - 60, height: screen.height / 3 - 50)
    }
}

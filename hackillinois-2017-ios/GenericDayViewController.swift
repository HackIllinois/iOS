//
//  GenericDayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class GenericDayViewController: GenericCardViewController, UICollectionViewDataSource {
    // Collection view to be configured
    weak var collectionView: UICollectionView!
    
    // Items
    var dayItems: [DayItem] = []
    
    override func viewDidLoad() {
        guard collectionView != nil else {
            fatalError("You must set a collectionView to refer to, before calling the superclass constructor")
        }
        
        super.viewDidLoad()
        
        /* Configure collection view */
        // More padding must be applied due to the scroll view
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 80, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        
        /* Reload data */
        collectionView.reloadData()
        
    }
    
    // Mark: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("day_one_cell", forIndexPath: indexPath) as! ScheduleCollectionViewCell
        let dayItem = dayItems[indexPath.row]
        /* Initialize Cell */
        cell.title.text = dayItem.name
        cell.location.text = dayItem.location
        cell.time.text = dayItem.time
        
        /* configure cell layout */
        configureCell(cell: cell)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screen = UIScreen.mainScreen().bounds
        return CGSize(width: screen.width - 60, height: 90)
    }
}

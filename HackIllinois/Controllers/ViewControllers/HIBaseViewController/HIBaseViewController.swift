//
//  HIBaseViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Lottie

class HIBaseViewController: UIViewController {

    // MARK: Properties
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    var refreshControl = UIRefreshControl()
    var refreshAnimation = LOTAnimationView(name: "loader_ring")

//    var updateOperations =  [(UICollectionView) -> Void]()
    var updateOperations = [BlockOperation]()

    @IBOutlet weak var collectionView: UICollectionView?

    // MARK: Object life cycle
    deinit {
        updateOperations.forEach { $0.cancel() }
        updateOperations.removeAll()
    }

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }

}

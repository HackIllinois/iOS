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

class HIBaseViewController: UIViewController {

    // MARK: Properties
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>?

    @IBOutlet weak var tableView: UITableView?

    // MARK: View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }

    // MARK: Alert presentation
    func presentErrorViewController(withTitle title: String, andMessage message: String? = nil, dismissParentOnCompletion exit: Bool) {

    }

}

//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    
    
//    and so this gets loaded with data that I can then access??
//     Fetched results controller for lazy loading of cells
//    var fetchedResultsController: NSFetchedResultsController<Feed>!
    var events = [Feed]()
    
    @IBOutlet weak var checkInTableView: UITableView!
//    @IBOutlet weak var startsInLabel: UILabel!
//    @IBOutlet weak var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fromRGBHex(mainUIColor);
        UIApplication.shared.statusBarStyle = .lightContent;
//        this is where this goes? maybe??
//        // Initialize Static data
//        initializeSample()
//        // Load objects from core data
//        loadSavedData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // first cell should always be the main cell
//        if (indexPath.row == 0) {
        if (true) { // currently if true for compiler sakes
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            return cell as UITableViewCell
        }
        // else check the data in the events array and call the correct cell class?
    }
}

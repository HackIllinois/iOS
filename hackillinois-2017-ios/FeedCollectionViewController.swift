//
//  FeedCollectionViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

private let reuseIdentifier = "feedCell"

class FeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    /* Variables */
    var refreshCleanUpRequired = false
    
    @IBOutlet weak var feedCollection: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    // Mark - Sample static data
    var sampleData: [Feed] = []
    
    func initializeSample() {
        // Temporary Locations
        let siebel = Location()
        siebel.name = "siebel"
        siebel.latitude = 40.1137074
        siebel.longitude = -88.2264893
        
        let eceb = Location()
        eceb.name = "eceb"
        eceb.latitude = 40.114828
        eceb.longitude = -88.228049
        
        let union = Location()
        union.name = "union"
        union.latitude = 40.109395
        union.longitude = -88.227181
        
        let hacking_start = Feed()
        hacking_start.message = "Hacking has begun!"
        hacking_start.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464042073))
        hacking_start.location = nil
        
        let lunch = Feed()
        lunch.message = "Lunch is served! Please come to ECEB or Siebel for Potbelly's Sandwiches!"
        lunch.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464038763))
        lunch.location = NSSet(array: [siebel, eceb])
        
        let cluehunt_start = Feed()
        cluehunt_start.message = "Cluehunt has begun!"
        cluehunt_start.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464040073))
        cluehunt_start.location = NSSet(array: [siebel, eceb])
        
        let dinner = Feed()
        dinner.message = "Dinner is going to be served in 10 minutes!"
        dinner.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464042073))
        dinner.location = NSSet(array: [siebel, eceb])
        
        let career_fair = Feed()
        career_fair.message = "Career fair is starting at the Union!"
        career_fair.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464042100))
        career_fair.location = NSSet(object: union)
        
        let dummy = Feed()
        dummy.message = "Replace me with real things"
        dummy.time = NSDate(timeIntervalSince1970: NSTimeInterval(1464041800))
        dummy.location = NSSet(array: [siebel, eceb, union])
        
        sampleData = [hacking_start, lunch, cluehunt_start, dinner, career_fair,
                      dummy, dummy, dummy, dummy, dummy, dummy, dummy, dummy, dummy]
        
        sampleData.sortInPlace({ (feed1, feed2) -> Bool in
            return feed1.time.compare(feed2.time).rawValue == 0
        })
    }
    
    // Mark - FeedCollectionViewController
    
    /* Refresh the feed... */
    func refresh() {
        print("refresh")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // Check to see if the method previously failed.
            if self.refreshCleanUpRequired {
                self.refreshControl.endRefreshing()
                // TODO: Different alert to user to wait a bit longer
                dispatch_async(dispatch_get_main_queue()) {
                    let ac = UIAlertController(title: "Timeout Error", message: "Please wait a little longer before trying again.", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(ac, animated: true, completion: nil)
                }
                return
            }
            
            // Set timeout so the user isn't stuck with a long running process...
            var timeout = false
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeoutIntervalSeconds * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                timeout = true
                self.refreshCleanUpRequired = true
                
                // End refresh
                self.refreshControl.endRefreshing()
                // Present warning to user
                let ac = UIAlertController(title: "Network Error", message: "Network connection has timed out. Please check your internet connection and try again later.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(ac, animated: true, completion: nil)
                return
            }
            
            // Get information from server
            sleep(20) // Fake server response
            print("Post condd")
            
            if timeout {
                // clean up
                print("clean up")
                self.refreshCleanUpRequired = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        
        // Layout the view to look more natural
        feedCollection.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 20, right: 0)
        
        // Set up refresh indicator
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.fromRGBHex(mainTintColor)])
        // Set refresh control look
        refreshControl.tintColor = UIColor.fromRGBHex(mainTintColor)
        refreshControl.bounds = CGRect(
            x: refreshControl.bounds.origin.x,
            y: 50,
            width: refreshControl.bounds.size.width,
            height: refreshControl.bounds.size.height)
        
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        feedCollection.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

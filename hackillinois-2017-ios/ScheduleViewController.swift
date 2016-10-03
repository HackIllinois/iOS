//
//  SchedulePageViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

enum DayOfWeek: Int {
    case friday = 0
    case saturday
    case sunday
}

class SchedulePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    fileprivate lazy var scheduleViewControllers: [UIViewController] = {
        return [self.getScheduleController("one"), self.getScheduleController("two"), self.getScheduleController("three")]
    }()
    
    func getScheduleController(_ name: String) -> UIViewController {
        return UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "schedule_day_\(name)")
    }
    
    // Views created to correct the color
    var navigationMask: UIView!
    var tabBarMask: UIView!
    
    // Animation Flag to prevent too many views from begin pushed onto the stack
    var isAnimating: Bool = true {
        didSet {
            // Make sure gestures cannot happen
            if isAnimating {
                self.tabBarController?.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
            } else {
                self.tabBarController?.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
    
    func alertScrollable() {
        // Alert to the user that the view is now scrollable
        let ac = UIAlertController(title: "Hint", message: "You can swipe left/right to view other days' schedule.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.bounds = view.frame.insetBy(dx: 0, dy: 40)
        self.dataSource = self
        self.delegate = self
        
        // Load initial view controller
        if let firstViewController = scheduleViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            self.navigationItem.title = "Friday"
        }
        
        isAnimating = false
        
        // Add instructions to indicate that user can scroll
        navigationController!.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_info_outline"), style: .done, target: self, action: #selector(alertScrollable))
    }
    
    // Mark: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Prevent scrolling when animating is occuring
        if isAnimating {
            return nil
        }
        
        let previousIndex = scheduleViewControllers.index(of: viewController)! - 1
        
        guard previousIndex >= 0 && previousIndex < scheduleViewControllers.count else {
            return nil
        }
        
        return scheduleViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Prevent scrolling when animating is occuring
        if isAnimating {
            return nil
        }
        
        let nextIndex = scheduleViewControllers.index(of: viewController)! + 1
        
        guard nextIndex >= 0 && nextIndex < scheduleViewControllers.count else {
            return nil
        }
        
        return scheduleViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (finished || completed) {
            isAnimating = false
        }
        
        if (!completed) {
            return
        }
        
        if let controller = pageViewController.viewControllers?[0] {
            switch scheduleViewControllers.index(of: controller)! {
            case DayOfWeek.friday.rawValue:
                self.navigationItem.title = "Friday"
            case DayOfWeek.saturday.rawValue:
                self.navigationItem.title = "Saturday"
            case DayOfWeek.sunday.rawValue:
                self.navigationItem.title = "Sunday"
            default:
                // Index is invalid
                return
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        isAnimating = true
        
    }
}

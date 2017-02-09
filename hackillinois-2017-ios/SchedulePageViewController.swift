//
//  ScheduleViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/29/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class SchedulePageViewController: UIPageViewController {
    var pageIndex: Int = -1
    var pageNames: [String] = ["schedule_friday", "schedule_saturday", "schedule_sunday"]
    var pageTurnedListener: ((from: Int, to: Int)) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set data source
        dataSource = self
        delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get a page
    func getPage(withId: Int) -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: pageNames[withId])
    }
    
    // Turn to page
    func turnPage(to: Int, withAnimation: Bool) {
        if to == pageIndex { return }
        let from = pageIndex
            
        setViewControllers([getPage(withId: to)], direction: to - pageIndex > 0 ? UIPageViewControllerNavigationDirection.forward: UIPageViewControllerNavigationDirection.reverse, animated: withAnimation, completion: nil)
        pageIndex = to
        
        // trigger listener
        pageTurnedListener((from: from, to: to))
    }
    
    // JS style callbacks
    // Note: Only one listener allowed
    func registerPageTurnedEventListener(listener: @escaping ((from: Int, to: Int)) -> Void) {
        pageTurnedListener = listener
    }
    
}

extension SchedulePageViewController: UIPageViewControllerDataSource {
    // Move Backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let view = viewController as! GenericTabController
        let index = view.dayIndex
        if 1 <= index && index <= 2 {
            pageIndex = index - 1
            return getPage(withId: pageIndex)
        } else {
            return nil
        }
    }
    
    // Move forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let view = viewController as! GenericTabController
        let index = view.dayIndex
        if 0 <= index && index <= 1 {
            pageIndex = index + 1
            return getPage(withId: pageIndex)
        } else {
            return nil
        }
    }
    
}

extension SchedulePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {
        if didFinishAnimating && transitionCompleted {
            let newView = pageViewController.viewControllers?.first as! GenericTabController
            let oldView = previousViewControllers.first as! GenericTabController
            let to = newView.dayIndex
            let from = oldView.dayIndex
            
            // trigger listener
            pageTurnedListener((from: from, to: to))
            pageIndex = to
        }
    }
}

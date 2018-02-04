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
    // MARK: - Properties
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    var refreshControl = UIRefreshControl()
    var refreshAnimation = LOTAnimationView(name: "refresh")
    var tableView: UITableView?
}

// MARK: - UIViewController
extension HIBaseViewController {
    override func loadView() {
        view = UIView()
        view.backgroundColor = HIColor.paleBlue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
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

// MARK: - UINavigationItem Setup
extension HIBaseViewController {
    @objc dynamic func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

// MARK: - UITableView Setup
extension HIBaseViewController {
    @objc dynamic func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension HIBaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HIBaseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = _fetchedResultsController?.sections?.count else { return 0 }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = _fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("tableView(_:, cellForRowAt:) must be implemented in a subclass of HIBaseViewController.")
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HIBaseViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath else { return }
            tableView?.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [toIndexPath], with: .fade)
            tableView?.deleteRows(at: [fromIndexPath], with: .fade)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections([sectionIndex], with: .fade)
        case .delete:
            tableView?.deleteSections([sectionIndex], with: .fade)
        case .update:
            tableView?.reloadSections([sectionIndex], with: .fade)
        case .move:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}

// MARK: - UITextFieldDelegate
extension HIBaseViewController: UITextFieldDelegate {
    @objc dynamic func nextReponder(current: UIResponder) -> UIResponder? {
        return nil
    }

    @objc dynamic func actionForFinalResponder() { }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextReponder = nextReponder(current: textField) {
            nextReponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            actionForFinalResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}

// MARK: - UIRefreshControl
extension HIBaseViewController {
    func setupRefreshControl() {
        // Setup refresh control
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(HIBaseViewController.refresh(_:)), for: .valueChanged)
        tableView?.addSubview(refreshControl)

        // Setup refresh animation
        refreshAnimation.alpha = 0.0
        refreshAnimation.loopAnimation = true
        refreshAnimation.contentMode = .scaleAspectFit
        refreshAnimation.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addSubview(refreshAnimation)

        // Constrain refresh animation
        refreshAnimation.leftAnchor.constraint(equalTo: refreshControl.leftAnchor).isActive = true
        refreshAnimation.rightAnchor.constraint(equalTo: refreshControl.rightAnchor).isActive = true
        refreshAnimation.centerYAnchor.constraint(equalTo: refreshControl.centerYAnchor).isActive = true
        refreshAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc dynamic func refresh(_ sender: UIRefreshControl) {
        fatalError("refresh(_:) must be implemented in a subclass of HIBaseViewController.")
    }

    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.refreshAnimation.loopAnimation = false
            self.refreshAnimation.completionBlock = { _ in
                self.refreshControl.endRefreshing()
                UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
                    self.refreshAnimation.alpha = 0.0
                }.startAnimation()
            }
        }
    }
}

// MARK: - Keyboard Notifications
extension HIBaseViewController {
    @objc dynamic func keyboardWillShow(_ notification: NSNotification) { }

    @objc dynamic func keyboardWillHide(_ notification: NSNotification) { }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func animateWithKeyboardLayout(notification: NSNotification, layout: ((CGRect) -> Void)?) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveValue),
            let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardFrameValue.cgRectValue

        layout?(keyboardFrame)

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
}

// MARK: - Alert Presentation
extension HIBaseViewController {
    func presentErrorController(title: String, message: String? = nil, dismissParentOnCompletion exit: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default) { (_) in
                if exit {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        )
        present(alert, animated: true, completion: nil)
    }
}

//
//  HIBaseViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/20/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import Lottie
import os

class HIBaseViewController: UIViewController {
    // MARK: - Properties
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    var refreshControl = UIRefreshControl()
    var refreshAnimation = AnimationView(name: "refresh")
    var tableView: UITableView?
    var backgroundView = UIImageView()
    let tableBackgroundView = HIView()
}

// MARK: - UIViewController
extension HIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundView()
        setupNavigationItem()
        setupTabBarItem()
        setupTableView()
        try? _fetchedResultsController?.performFetch()
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

// MARK: - UIImageView Setup
extension HIBaseViewController {
    @objc dynamic func setUpBackgroundView() {
        view.layer.backgroundColor = UIColor.clear.cgColor
        backgroundView.image = #imageLiteral(resourceName: "Gradient")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = true
        backgroundView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundView, at: 0)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

// MARK: - UIStackView Population
func populateTagLabels(stackView: UIStackView, tagsString: String) {
    if stackView.subviews.count != 0 { return }
    if tagsString.isEmpty { return }
    let tags = tagsString.components(separatedBy: ",")
    let padding = "    "
    for tag in tags {
        let tagLabel = HILabel {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.font = HIAppearance.Font.contentText
            $0.backgroundHIColor = \.clear
            switch tag.uppercased() {
            case "WEB DEVELOPMENT":
                $0.text = "Web" + padding
                $0.layer.backgroundColor = UIColor(red: 0.42, green: 0.682, blue: 0.773, alpha: 1).cgColor
                $0.textHIColor = \.whiteTagFont
            case "SYSTEMS":
                $0.text = "Systems" + padding
                $0.layer.backgroundColor = UIColor(red: 0.643, green: 0.231, blue: 0.361, alpha: 1).cgColor
                $0.textHIColor = \.whiteTagFont
            case "LANGUAGES":
                $0.text = "Languages" + padding
                $0.layer.backgroundColor = UIColor(red: 0.659, green: 0.796, blue: 0.718, alpha: 1).cgColor
                $0.textHIColor = \.whiteTagFont
            case "DATA SCIENCE":
                $0.text = "Data Science" + padding
                $0.layer.backgroundColor = UIColor(red: 0.886, green: 0.545, blue: 0.475, alpha: 1).cgColor
                $0.textHIColor = \.whiteTagFont
            default:
                $0.text = tag + padding
                $0.textColor = .white
                $0.layer.backgroundColor = UIColor.systemTeal.cgColor
            }
        }
        tagLabel.layer.cornerRadius = 8.0
        stackView.addArrangedSubview(tagLabel)
    }
}

// MARK: - UINavigationItem Setup
extension HIBaseViewController {
    @objc dynamic func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

// MARK: - UITabBarItem Setup
extension HIBaseViewController {
    @objc dynamic func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: self.title, image: nil, tag: 0)
    }
}

// MARK: - UITableView Setup
extension HIBaseViewController {
    @objc dynamic func setupTableView() {
        tableView?.layer.backgroundColor = UIColor.clear.cgColor
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
        let sectionCount = _fetchedResultsController?.sections?.count ?? 0
        if sectionCount > 0 {
            if _fetchedResultsController?.sectionNameKeyPath == nil {
                if _fetchedResultsController?.sections?[0].numberOfObjects ?? 0 > 0 {
                    tableView.backgroundView = nil
                } else {
                    tableView.backgroundView = tableBackgroundView
                }
            } else {
                tableView.backgroundView = nil
            }
        } else {
            tableView.backgroundView = tableBackgroundView
        }
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

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
            if let tableView = tableView {
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(false)
                    UIView.animate(withDuration: 0.0, animations: tableView.reloadData) { _ in
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
        case .update:
            guard let updateIndexPath = indexPath else { return }
            tableView?.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView?.moveRow(at: fromIndexPath, to: toIndexPath)
        @unknown default:
            os_log(
                "Unknown NSFetchedResultsChangeType %s",
                log: Logger.ui,
                type: .info,
                String(describing: type)
            )
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections([sectionIndex], with: .fade)
        case .delete:
            tableView?.deleteSections([sectionIndex], with: .fade)
        case .update:
            tableView?.reloadSections([sectionIndex], with: .fade)
        case .move:
            break
        @unknown default:
            os_log(
                "Unknown NSFetchedResultsChangeType %s",
                log: Logger.ui,
                type: .info,
                String(describing: type)
            )
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }

    func animateTableViewReload() {
        if let tableView = tableView {
            UIView.transition(
                with: tableView,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    tableView.reloadData()
            })
        }
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
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView?.insertSubview(refreshControl, at: 0)

        // Setup refresh animation
        refreshAnimation.alpha = 0.0
        refreshAnimation.loopMode = .loop
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
        refreshAnimation.currentFrame = 0
        refreshAnimation.play()
        UIViewPropertyAnimator(duration: 0.125, curve: .linear) {
            self.refreshAnimation.alpha = 1.0
        }.startAnimation()
    }

    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            let animator = UIViewPropertyAnimator(duration: 0.125, curve: .linear) {
                self.refreshAnimation.alpha = 0.0
            }
            animator.addCompletion { _ in
                self.refreshAnimation.stop()
                self.refreshControl.endRefreshing()
            }
            animator.startAnimation()
        }
    }
}

// MARK: - Keyboard Notifications
extension HIBaseViewController {
    @objc dynamic func keyboardWillShow(_ notification: NSNotification) { }

    @objc dynamic func keyboardWillHide(_ notification: NSNotification) { }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func animateWithKeyboardLayout(notification: NSNotification, layout: ((CGRect) -> Void)?) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue),
            let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

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

//
//  HIEventPopupViewController.swift
//  HackIllinois
//
//  Created by Aryan Nambiar on 1/1/22.
//  Copyright © 2022 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol HIEventPopupViewDelegate: AnyObject {
    func setIsInitialCheckin(_ value: Bool)
    func setSelectedEvent(_ event: String)
}

class HIEventPopupViewController: UIViewController {
    // MARK: Properties
    weak var delegate: HIEventPopupViewDelegate?

    let interests = HIInterestDataSource.shared.interestOptions
    let popupTableView = HITableView()
    var selectedRows: Set<Int>?
    var events: [Event] = []
    var names: [String] = []
    var eventIds: [String] = []

    private let containerView = HIView {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.white
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentHorizontalAlignment = .left
        $0.tintHIColor = \.black
        $0.tintColor = .black
        $0.titleHIColor = \.titleText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "CloseButton")
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
        if #available(iOS 13.0, *) {
            $0.activeImage = $0.activeImage?.withTintColor(.black)
            $0.baseImage = $0.baseImage?.withTintColor(.black)
        }
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
}

// MARK: Actions
extension HIEventPopupViewController {
    @objc func didSelectClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSelectBackground(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewController
extension HIEventPopupViewController {
    override func viewDidLoad() {
        HICoreDataController.shared.performBackgroundTask { context -> Void in
            do {
                let eventFetchRequest = NSFetchRequest<Event>(entityName: "Event")
                self.events = try context.fetch(eventFetchRequest)
                self.names = self.events.map { $0.name }
                self.names.insert("Initial Checkin", at: 0)
                self.eventIds = self.events.map { $0.id }
            }
            catch {}
        }
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        popupTableView.reloadData()
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        let selectSortLabel = HILabel(style: .sortText)
        selectSortLabel.text = "What are you scanning?"
        selectSortLabel.textColor = .black

        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true

        containerView.addSubview(exitButton)
        exitButton.constrain(to: containerView, topInset: 8, leadingInset: 8)

        containerView.addSubview(selectSortLabel)
        selectSortLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10).isActive = true
        selectSortLabel.leadingAnchor.constraint(equalTo: exitButton.leadingAnchor, constant: 8).isActive = true
        selectSortLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        containerView.addSubview(popupTableView)
        popupTableView.topAnchor.constraint(equalTo: selectSortLabel.bottomAnchor, constant: 20).isActive = true
        popupTableView.leadingAnchor.constraint(equalTo: selectSortLabel.leadingAnchor).isActive = true
        popupTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35).isActive = true
        popupTableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

    }
}

// MARK: - UIGestureRecognizerDelegate
extension HIEventPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

// MARK: - UITableView Setup
extension HIEventPopupViewController {
    func setupTableView() {
        popupTableView.alwaysBounceVertical = false
        popupTableView.register(HIGroupPopupCell.self, forCellReuseIdentifier: HIGroupPopupCell.identifier)
        popupTableView.dataSource = self
        popupTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension HIEventPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGroupPopupCell.identifier, for: indexPath)
        if let cell = cell as? HIGroupPopupCell {
            cell.selectionStyle = .none
            cell.selectedImageView.isHidden = true
            cell.interestLabel.text = names[indexPath.row]
            cell.interestLabel.textColor = .black
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIEventPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.setIsInitialCheckin(true)
        } else {
            delegate?.setSelectedEvent(eventIds[indexPath.row-1])
        }
        dismiss(animated: true)
    }
}

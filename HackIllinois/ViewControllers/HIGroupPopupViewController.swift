//
//  HIGroupPopupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/1/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

protocol HIGroupPopupViewDelegate: class {
    func updateInterests(_ groupPopupCell: HIGroupPopupCell)
}

class HIGroupPopupViewController: UIViewController {
    // MARK: Properties
    weak var delegate: HIGroupPopupViewDelegate?
    let interests = ["AWS", "C++", "Project Management", "Python", "Docker", "Java", "ML", "Swift", "Go", "Javascript", "C", "Typescript"]
    var hiInterests: [HIInterest] = []
    let popupTableView = HITableView()
    var selectedRows: Set<Int>?

    private let containerView = HIView {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.buttonViewBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentHorizontalAlignment = .left
        $0.tintHIColor = \.qrTint
        $0.titleHIColor = \.qrTint
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "CloseButton")
        $0.baseImage = #imageLiteral(resourceName: "CloseButton")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
}

// MARK: Actions
extension HIGroupPopupViewController {
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
extension HIGroupPopupViewController {
    override func viewDidLoad() {
        guard let selectedRows = selectedRows else { return }
        for (index, interest) in interests.enumerated() {
            let newHIInterest = HIInterest(name: interest, selected: selectedRows.contains(index))
            hiInterests.append(newHIInterest)
        }
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        popupTableView.reloadData()
        view.layoutIfNeeded()
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectBackground))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        let selectSortLabel = HILabel(style: .sortText)
        selectSortLabel.text = "Select Skills"

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
extension HIGroupPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

// MARK: - UITableView Setup
extension HIGroupPopupViewController {
    func setupTableView() {
        popupTableView.alwaysBounceVertical = false
        popupTableView.register(HIGroupPopupCell.self, forCellReuseIdentifier: HIGroupPopupCell.identifier)
        popupTableView.dataSource = self
        popupTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension HIGroupPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGroupPopupCell.identifier, for: indexPath)
        if let cell = cell as? HIGroupPopupCell {
            cell.selectionStyle = .none
            cell <- hiInterests[indexPath.row]
            cell.indexPath = indexPath
        }
        return cell
    }

}

// MARK: - UITableViewDelegate
extension HIGroupPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell as? HIGroupPopupCell {
            let currentInterest = hiInterests[indexPath.row]
            hiInterests[indexPath.row] = HIInterest(name: currentInterest.name, selected: !currentInterest.selected)
            delegate?.updateInterests(cell)
        }
        tableView.reloadData()
    }
}

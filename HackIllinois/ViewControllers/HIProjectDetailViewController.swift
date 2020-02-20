//
//  HIProjectDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/25/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import MapKit
import HIAPI
import APIManager

class HIProjectDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var project: Project?

    // MARK: Views
    private let closeButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "MenuClose")
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
    }

    private let projectDetailContainer = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }

    private let titleLabel = HILabel(style: .detailTitle) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.font = HIAppearance.Font.detailTitle
    }

    private let mentorLabel = HILabel(style: .detailSubtitle) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
        $0.numberOfLines = 0
    }
    private let numberLabel = HILabel(style: .detailSubtitle) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
    }
    private let locationLabel = HILabel(style: .detailSubtitle) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
    }

    private let descriptionLabel = HILabel(style: .detailText) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor <- \.baseText
    }
    private let favoritedButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "Favorited")
        $0.baseImage = #imageLiteral(resourceName: "Unfavorited")
    }
    private let gradient = CAGradientLayer()
    private let tagScrollView = UIScrollView()
    private let tagStackView = UIStackView()

    // MARK: Constraints
    private var descriptionLabelHeight = NSLayoutConstraint()
    private var tableViewHeight = NSLayoutConstraint()
}

// MARK: - Actions
extension HIProjectDetailViewController {
    @objc func didSelectFavoriteButton(_ sender: HIButton) {
        guard let project = project else { return }

        let changeFavoriteStatusRequest: APIRequest<ProjectFavorites> =
            sender.isActive ?
                HIAPI.ProjectService.unfavoriteBy(id: project.id) :
                HIAPI.ProjectService.favoriteBy(id: project.id)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    sender.isActive.toggle()
                    project.favorite.toggle()
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }

    @objc func didSelectCloseButton(_ sender: HIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateGradientBounds()
    }

    func updateGradientBounds() {
        gradient.frame = CGRect(
            x: tagScrollView.contentOffset.x,
            y: 0,
            width: tagScrollView.bounds.width,
            height: tagScrollView.bounds.height
        )

        let contentSize = tagScrollView.contentSize.width - tagScrollView.frame.size.width - 1
        switch tagScrollView.contentOffset.x {
        case let offset where offset <= 0:
            gradient.locations = [0, 0, 0.95, 1]
        case let offset where offset >= contentSize:
            gradient.locations = [0, 0.05, 1, 1]
        default:
            gradient.locations = [0, 0.05, 0.95, 1]
        }
    }
}

// MARK: - UIViewController
extension HIProjectDetailViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        closeButton.constrain(height: 20)

        view.addSubview(projectDetailContainer)
        projectDetailContainer.constrain(to: view.safeAreaLayoutGuide, trailingInset: -8, bottomInset: 0, leadingInset: 8)
        projectDetailContainer.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true

        projectDetailContainer.addSubview(tagScrollView)
        setupTagItems()

        projectDetailContainer.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: projectDetailContainer.leadingAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 15).isActive = true

        favoritedButton.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
        projectDetailContainer.addSubview(favoritedButton)
        favoritedButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        favoritedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        favoritedButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        favoritedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        favoritedButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoritedButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

        projectDetailContainer.addSubview(mentorLabel)
        mentorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        mentorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        mentorLabel.trailingAnchor.constraint(equalTo: favoritedButton.leadingAnchor).isActive = true

        setupLabels()
    }

    func setupLabels() {

        projectDetailContainer.addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: mentorLabel.bottomAnchor, constant: 5).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: mentorLabel.leadingAnchor).isActive = true

        projectDetailContainer.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor).isActive = true

        projectDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30).isActive = true
        descriptionLabel.constrain(to: projectDetailContainer, trailingInset: -12)
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        descriptionLabelHeight.isActive = true
    }

    func setupTagItems() {
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.leadingAnchor.constraint(equalTo: projectDetailContainer.leadingAnchor, constant: 12).isActive = true
        tagScrollView.topAnchor.constraint(equalTo: projectDetailContainer.topAnchor, constant: 30).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: projectDetailContainer.trailingAnchor, constant: -12).isActive = true
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.delegate = self

        tagStackView.axis = .horizontal
        tagStackView.alignment = .fill
        tagStackView.distribution = .equalSpacing
        tagStackView.spacing = 5.0
        tagStackView.translatesAutoresizingMaskIntoConstraints = false

        tagScrollView.addSubview(tagStackView)
        tagStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagStackView.bottomAnchor.constraint(equalTo: tagScrollView.bottomAnchor).isActive = true
        tagStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true

        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.delegate = self
        tagScrollView.layer.mask = gradient
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let project = project else { return }
        titleLabel.text = project.name
        descriptionLabel.text = project.info
        favoritedButton.isActive = project.favorite
        mentorLabel.text = "Mentor(s): \(project.mentors.replacingOccurrences(of: ",", with: ", "))"
        numberLabel.text = "Table #\(project.number)"
        locationLabel.text = "Meeting Room: \(project.room)"
        populateTagLabels(stackView: tagStackView, tagsString: project.tags)

        tableView?.reloadData()
        view.layoutIfNeeded()
        updateGradientBounds()
        let targetSize = CGSize(width: descriptionLabel.frame.width, height: .greatestFiniteMagnitude)
        let neededSize = descriptionLabel.sizeThatFits(targetSize)
        descriptionLabelHeight.constant = neededSize.height
        tableViewHeight.constant = 1 * 160 //Update in UI: Projects have one indoor location
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if project == nil {
            presentErrorController(title: "Uh oh", message: "Failed to load project.", dismissParentOnCompletion: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tagStackView.arrangedSubviews.forEach { (view) in
            tagStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIProjectDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "PROJECT DETAILS"
    }
}

// MARK: - UITableView Setup
extension HIProjectDetailViewController {
    override func setupTableView() {
        tableView?.alwaysBounceVertical = false
        tableView?.register(HIEventDetailLocationCell.self, forCellReuseIdentifier: HIEventDetailLocationCell.identifier)
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIProjectDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard project != nil else { return 0 }
        return 1 //Projects have one location
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventDetailLocationCell.identifier, for: indexPath)
        //Update in UI: Projects should have an indoor location with a HIProjectDetailLocationCell
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIProjectDetailViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Update in UI: Projects should have an indoor location cell that routes to one of the buildings for outdoor maps (or routes to indoor maps?)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - CALayerDelegate
extension HIProjectDetailViewController: CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

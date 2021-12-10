//
//  HICarouselView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HICarouselView: UIView {
    struct CarouselData {
        let image: UIImage?
        let titleText: String
        let descriptionText: String
    }
    // MARK: - Subviews
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(HICarouselCell.self, forCellWithReuseIdentifier: HICarouselCell.cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    // MARK: - Properties
    private var pages: Int

    private var carouselData = [CarouselData]()
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    // MARK: - Initializers
    init(pages: Int) {
        self.pages = pages
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

private extension HICarouselView {
    func setupUI() {
        backgroundColor = .clear
        setupPageControl()
        setupCollectionView()
    }
    func setupCollectionView() {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        addSubview(carouselCollectionView)
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 0).isActive = true
        carouselCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        carouselCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        carouselCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.numberOfPages = pages
    }
}

// MARK: - UICollectionViewDataSource

extension HICarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HICarouselCell.cellId, for: indexPath) as? HICarouselCell else { return UICollectionViewCell() }
        let image = carouselData[indexPath.row].image
        let titleText = carouselData[indexPath.row].titleText
        let descriptionText = carouselData[indexPath.row].descriptionText

        cell.configure(image: image, titleText: titleText, descriptionText: descriptionText)
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension HICarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}

// MARK: - Public

extension HICarouselView {
    public func configureView(with data: [CarouselData]) {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        carouselData = data
        carouselCollectionView.reloadData()
    }
}

// MARK: - Helpers

private extension HICarouselView {
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
}

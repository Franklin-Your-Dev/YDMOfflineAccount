//
//  SpaceyGridCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 25/05/21.
//

import UIKit
import YDB2WModels
import YDExtensions

class SpaceyGridCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var items: [YDSpaceyComponentsTypes] = []

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  lazy var heightConstraint: NSLayoutConstraint = {
    let height = collectionView.heightAnchor.constraint(equalToConstant: 50)
    height.isActive = true
    return height
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life cycle
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    heightConstraint.constant = collectionView.collectionViewLayout
      .collectionViewContentSize.height
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    items = []
    collectionView.reloadData()
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentGrid) {
//    if let numberOfColumns = component.numberOfColumns {
//      configureCollectionViewLayout(numberOfColumns: numberOfColumns)
//    }

    items = component.children
    collectionView.reloadData()
    heightConstraint.constant = 100
    // collectionView.setNeedsLayout()
  }
}

// MARK: Layout
extension SpaceyGridCollectionViewCell {
  func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    configureCollectionViewLayout(numberOfColumns: 1)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])

    // Register Cells
    YDSpaceyHelper.registerCells(in: collectionView, for: .grid)
  }

  func configureCollectionViewLayout(numberOfColumns: Int) {
    collectionView.collectionViewLayout = YDSpaceyHelper.configureCollectionLayout(
      numberOfColumns: numberOfColumns,
      inside: contentView
    )
//    collectionView.collectionViewLayout.invalidateLayout()
  }
}
